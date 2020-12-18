DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_adres`(out id int,woj varchar(45), mia varchar(45), ul varchar(45), kod varchar(45),nrdom int,nrmie int)
BEGIN
 set @id = 0;
call baza_projekt.id_adres(@id,woj,mia,ul,kod,nrdom,nrmie);

if(@id > 0)
then
	set id = @id;
else 
	INSERT INTO `adres`(`wojewodztwo`, `miasto`, `ulica`, `kod-pocztowy`, `nr_domu`, `nr_mieszkania`) VALUES 
	(woj,mia,ul,kod,nrdom,nrmie);
	call baza_projekt.id_adres(@id,woj,mia,ul,kod,nrdom,nrmie);
set id = @id;

end if;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_klienta`(out id int,imie varchar(45), nazwisko varchar(45),telefon varchar(12), email varchar(45),wojewodztwo varchar(45), miasto varchar(45), ulica varchar(45), kod_pocztowy varchar(6),nr_domu int,nr_mieszkania int)
BEGIN
	
    set @ida = 0;
	call baza_projekt.dodaj_adres(@ida, wojewodztwo, miasto, ulica, kod_pocztowy, nr_domu,nr_mieszkania);
    set @idk = 0;
	call baza_projekt.id_klient(@idk, imie, nazwisko, telefon, email, @ida);
    
    if(@idk > 0)
    then
		set id =@idk;
    else 
		INSERT INTO `klient`( `imie`, `nazwisko`, `idadres`, `telefon`, `email`, `ilosc_nadanych_przesylek`) VALUES (imie,nazwisko,@ida,telefon,email,0);
        call baza_projekt.id_klient(@idk, imie, nazwisko, telefon, email, @ida);
        set id =@idk;
    end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_kuriera`(out id int,imie varchar(45), nazwisko varchar(45),telefon varchar(12), email varchar(45),wojewodztwo varchar(45), miasto varchar(45), ulica varchar(45), kod_pocztowy varchar(6),nr_domu int,nr_mieszkania int)
BEGIN
	
    set @ida = 0;
	call baza_projekt.dodaj_adres(@ida, wojewodztwo, miasto, ulica, kod_pocztowy, nr_domu,nr_mieszkania);
    set @idk = 0;
	call baza_projekt.id_kurier(@idk, imie, nazwisko, telefon, email, @ida);
    
    if(@idk > 0)
    then
		set id =@idk*-1;
    else 
		INSERT INTO `kurier`( `imie`, `nazwisko`, `idadres`, `telefon`, `email`, `czy_wolny`, `ilosc_dostarczonych_przesylek`) VALUES 
        (imie,nazwisko,@ida,telefon,email,'t',0);
        call baza_projekt.id_kurier(@idk, imie, nazwisko, telefon, email, @ida);
        set id =@idk;
    end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostarcz_przesylke`(idkuriera int)
BEGIN
	UPDATE informacje_o_przesylce
    SET czy_dostarczona='t'
    WHERE idkurier=idkuriera;
    
    UPDATE informacje_o_przesylce
    SET data_doreczenia=now()
    WHERE idkurier=idkuriera;
    
    UPDATE `kurier` 
    SET `ilosc_dostarczonych_przesylek`= `ilosc_dostarczonych_przesylek`+1
    WHERE idkurier=idkuriera;
    
    UPDATE `kurier` 
    SET `czy_wolny`='t' 
    WHERE idkurier=idkuriera;
    
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_zamowienie`(out nr int,
imie_n varchar(45),nazwisko_n varchar(45),telefon_n varchar(12),email_n varchar(45),woj_n varchar(45),mia_n varchar(45),ul_n varchar(45),kod_n varchar(6),nrdomu_n int,nrmieszkania_n int,
imie_o varchar(45),nazwisko_o varchar(45),telefon_o varchar(12),email_o varchar(45),woj_o varchar(45),mia_o varchar(45),ul_o varchar(45),kod_o varchar(6),nrdomu_o int,nrmieszkania_o int,
towar varchar(45), ilosc int, waga_jednej_szt int
)
BEGIN

	set @idnadawca = 0;
	call baza_projekt.dodaj_klienta(@idnadawca,imie_n ,nazwisko_n ,telefon_n ,email_n ,woj_n, mia_n, ul_n, kod_n,nrdomu_n ,nrmieszkania_n );
    UPDATE `klient` SET `ilosc_nadanych_przesylek`=`ilosc_nadanych_przesylek`+1 WHERE `idklient`= @idnadawca;
	
    set @idodbiorca = 0;
	call baza_projekt.dodaj_klienta(@idodbiorca,imie_o ,nazwisko_o ,telefon_o ,email_o ,woj_o, mia_o, ul_o, kod_o,nrdomu_o ,nrmieszkania_o );

	set @idkurier = 0;

	set @idtowar = 0;
	call baza_projekt.dodaj_towar(@idtowar, towar,ilosc ,waga_jednej_szt );
    
    set @typ_przesylki = 0;
    set @waga = ilosc*waga_jednej_szt;
    if((0<@waga) and (@waga<=5))
    then
    set @typ_przesylki=1;
    end if;
    
    if((5<@waga) and (@waga<=15))
    then
    set @typ_przesylki=2;
    end if;
    
    if((15<@waga) and (@waga<=20))
    then
    set @typ_przesylki=4;
    end if;
    
    if((20<@waga) and (@waga<=300))
    then
    set @typ_przesylki=3;
    end if;
    
    set @cena_przesylki = 0;
    select cena into @cena_przesylki from typ_przesylki
    where idtyp_przesylki=@typ_przesylki;
    
    set @idinfo = 0;
    SELECT `idinformacje_o_przesylce` into @idinfo FROM `informacje_o_przesylce` WHERE 
    `idtowar`=@idtowar and
    `idnadawca`=@idnadawca and
    `idodbiorca`=@idodbiorca and
    `idtypprzesylki`=@typ_przesylki and
    `idkurier`=@idkurier and
    `czy_dostarczona`="n" and
    `data_doreczenia`='0000-00-00' and
    `cena_przesylki`=@cena_przesylki
    ;
    
    if(@idinfo > 0)
    then
		set @b=0;
    else
    INSERT INTO `informacje_o_przesylce`(`idtowar`, `idnadawca`, `idodbiorca`, `idtypprzesylki`, `idkurier`, `czy_dostarczona`, `data_doreczenia`, `cena_przesylki`) VALUES 
    (@idtowar,@idnadawca,@idodbiorca,@typ_przesylki,@idkurier,'n','0000-00-00',@cena_przesylki);
    
    SELECT `idinformacje_o_przesylce` into @idinfo FROM `informacje_o_przesylce` WHERE 
    `idtowar`=@idtowar and
    `idnadawca`=@idnadawca and
    `idodbiorca`=@idodbiorca and
    `idtypprzesylki`=@typ_przesylki and
    `idkurier`=@idkurier and
    `czy_dostarczona`="n" and
    `data_doreczenia`='0000-00-00' and
    `cena_przesylki`=@cena_przesylki
    ;
    end if;
    
    
    
    
    
    -- select @idinfo;
     
     
     
     set @nr_zamowienia =@idnadawca*@idodbiorca*@cena_przesylki*@idtowar*@typ_przesylki*(now() mod 30)+1;
    
     INSERT INTO `do_doreczenia`( `nr`, `data`, `czy_gotowa`, `opis`, `idinformacjeoprzesylce`) VALUES
     (@nr_zamowienia,NOW(),'n',NULL,@idinfo);
    
    set nr=@nr_zamowienia;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_towar`(out id int, nazwa varchar(45), ilosc int, waga_jednej_szt int)
BEGIN
set @idt = 0;
call baza_projekt.id_towar(@idt, nazwa, ilosc, waga_jednej_szt);

if(@idt>0)
then
	set id=@idt;
    
else
	INSERT INTO `towar`( `nazwa`, `ilosc`, `waga_jednej_szt`) VALUES 
    (nazwa, ilosc, waga_jednej_szt);
    call baza_projekt.id_towar(@idt, nazwa, ilosc, waga_jednej_szt);
    set id=@idt;
end if;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_adres`(out id int, woj varchar(45), mia varchar(45), ul varchar(45), kod varchar(45),nrdom int,nrmie int)
BEGIN
select idadres into id from baza_projekt.adres as a
where a.wojewodztwo=woj
and a.miasto=mia
and a.ulica=ul
and a.`kod-pocztowy`=kod
and a.nr_domu=nrdom
and a.nr_mieszkania=nrmie
;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_klient`(out id int, imie varchar(45), nazwisko varchar(45),telefon varchar(12), email varchar(45), ida int)
BEGIN

SELECT `idklient` into id FROM `klient` as k WHERE 
k.`imie`= imie
and k.`nazwisko`=nazwisko
and k.`idadres`=ida
and k.`telefon`=telefon
and k.`email`=email
;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_kurier`(out id int, imie varchar(45), nazwisko varchar(45),telefon varchar(12), email varchar(45), ida int)
BEGIN

SELECT `idkurier` into id FROM `kurier` as k WHERE 
k.`imie`= imie
and k.`nazwisko`=nazwisko
and k.`idadres`=ida
and k.`telefon`=telefon
and k.`email`=email;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `id_towar`(out id int, nazwa varchar(45), ilosc int, waga_jednej_szt int)
BEGIN

SELECT `idtowar`into id FROM `towar` as t WHERE 
t.`nazwa`=nazwa
and t.`ilosc`=ilosc
and t.`waga_jednej_szt`=waga_jednej_szt
;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `nr_przesylki_bez_kuriera`()
BEGIN
	select nr from baza_projekt.do_doreczenia as dd
    inner join baza_projekt.informacje_o_przesylce as info
    on dd.idinformacjeoprzesylce=info.idinformacje_o_przesylce
    where info.idkurier=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `przydziel_kuriera_do_przesylki`(idkuriera int, nrprzesylki int)
BEGIN

	UPDATE informacje_o_przesylce as info
    inner join do_doreczenia as dd
    on dd.idinformacjeoprzesylce=info.idinformacje_o_przesylce
    SET idkurier=idkuriera 
    WHERE dd.nr=nrprzesylki;
    
    UPDATE `do_doreczenia` 
    SET `czy_gotowa`='t'
    WHERE nr=nrprzesylki;
    
    UPDATE `kurier` 
    SET `czy_wolny`='n' 
    WHERE idkurier=idkuriera;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wolni_kurierzy`()
BEGIN
	select idkurier,imie, nazwisko from baza_projekt.kurier
    where czy_wolny = 't';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wyswietl_rodzaje_przesylek`()
BEGIN
	select tp.idtyp_przesylki as nr, nazwa,waga_max as 'waga maksymalna przesyłki',przewidywany_czas_dostawy as 'przewidywany czas dostawy',cena from baza_projekt.typ_przesylki as tp;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `zajeci_kurierzy`()
BEGIN
	select idkurier,imie, nazwisko from baza_projekt.kurier
    where czy_wolny = 'n';
END$$
DELIMITER ;
