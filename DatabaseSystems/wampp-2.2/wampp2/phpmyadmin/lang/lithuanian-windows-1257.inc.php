<?php
/* $Id: lithuanian-windows-1257.inc.php,v 1.97 2003/05/31 10:46:06 lem9 Exp $ */

$charset = 'windows-1257';
$text_dir = 'ltr'; // ('ltr' for left to right, 'rtl' for right to left)
$left_font_family = 'verdana, arial, helvetica, geneva, sans-serif';
$right_font_family = 'arial, helvetica, geneva, sans-serif';
$number_thousands_separator = ',';
$number_decimal_separator = '.';
// shortcuts for Byte, Kilo, Mega, Giga, Tera, Peta, Exa
$byteUnits = array('B', 'KB', 'MB', 'GB');

$day_of_week = array('Sekmadienis', 'Pirmadienis', 'Antradienis', 'Tre?iadienis', 'Ketvirtadienis', 'Penktadienis', '?e?tadienis');
$month = array('Sausio', 'Vasario', 'Kovo', 'Baland?io', 'Gegu?io', 'Bir?elio', 'Liepos', 'Rugpj??io', 'Rugs?jo', 'Spalio', 'Lapkri?io', 'Gruod?io');
// See http://www.php.net/manual/en/function.strftime.php to define the
// variable below
$datefmt = ' %Y m. %B %d d.  %H:%M';
$timespanfmt = '%s d., %s val., %s min. ir %s s.';

$strAPrimaryKey = 'Stulpeliui %s sukurtas PIRMINIS raktas';
$strAbortedClients = 'Atmesti prisijungimai';
$strAbsolutePathToDocSqlDir = 'Pra?ome nurodyti absoliut? keli? iki docSQL katalogo serveryje';
$strAccessDenied = 'Pri?jimas u?draustas';
$strAction = 'Valdymo veiksmai';
$strAddDeleteColumn = '?terpti/Trinti stulpelius';
$strAddDeleteRow = '?terpti/Trinti po?ymio eilut?(es)';
$strAddNewField = '?terpti nauj? laukel?(ius)';
$strAddPriv = '?terpti privilegij?(as)';
$strAddPrivMessage = 'J?s ?terp?te privilegijas.';
$strAddPrivilegesOnDb = 'Sukurti privilegijas ?iai duomen? bazei';
$strAddPrivilegesOnTbl = 'Sukurti privilegijas ?iai lentelei';
$strAddSearchConditions = '?terpkite paie?kos s?lygas ? "where" sakin?:';
$strAddToIndex = '?terpti indeksui papildomus &nbsp;%s&nbsp;stulpel?(ius)';
$strAddUser = 'Sukurti nauj? vartotoj?';
$strAddUserMessage = 'J?s suk?r?te nauj? vartotoj?.';
$strAddedColumnComment = 'Prid?tas stulpelio komentaras';
$strAddedColumnRelation = 'Prid?tas stulpelio s?ry?is';
$strAdministration = 'Administracija';
$strAffectedRows = 'Pakeista eilu?i?:';
$strAfter = 'Po %s';
$strAfterInsertBack = 'Sugr??ti ? buvus? puslap?';
$strAfterInsertNewInsert = '?terpti sekan?i? nauj? eilut?';
$strAll = 'Visk?';
$strAllTableSameWidth = 'rodyti visas lenteles vienodo plo?io?';
$strAlterOrderBy = 'Pakeisti lentel?s r??iavim? pagal:';
$strAnIndex = 'Indeksas sukurtas %s stulpeliui';
$strAnalyzeTable = 'Analizuoti lentel?';
$strAnd = 'IR';
$strAny = 'Bet kur?(i?)';
$strAnyColumn = 'Bet kur? stulpel?';
$strAnyDatabase = 'Bet kuri? duomen? baz?';
$strAnyHost = 'Bet kur? prisijungimo adres?';
$strAnyTable = 'Bet kuri? lentel?';
$strAnyUser = 'Bet kur? vartotoj?';
$strAscending = 'Did?jimo tvarka';
$strAtBeginningOfTable = 'Lentel?s prad?ioje';
$strAtEndOfTable = 'Lentel?s pabaigoje';
$strAttr = 'Atributai';
$strAutodetect = 'Automatinis nustatymas';  
$strAutomaticLayout = 'Automatinis i?d?stymas';  

$strBack = 'Atgal';
$strBeginCut = 'KIRPIMO PRAD?IA';
$strBeginRaw = 'RAW PRAD?IA';
$strBinary = 'Dvejetainis';
$strBinaryDoNotEdit = 'Dvejetainis - nekeisti';
$strBookmarkDeleted = 'Nuoroda i?trinta.';
$strBookmarkLabel = 'Nuorodos Antra?t?';
$strBookmarkQuery = 'Sukurti nuoroda SQL-u?klausai';
$strBookmarkThis = 'Sukurti nuorod?';
$strBookmarkView = 'Per?i?ra';
$strBrowse = 'Per?i?r?ti';
$strBzError = 'phpMyAdmin negal?jo suspausti lentel?s strukt?ros atvaizd? (dump), nes ?ioje php versijoje neveikia Bz2 modulis. Rekomenduojame phpMyAdmin konfig?racin?je byloje <code>$cfg[\'BZipDump\']</code> direktyv? prilyginti <code>FALSE</code>. Atnaujinkite savo php versij?, jeigu norite naudotis Bz2 moduliu. Detalesn? informacija: %s.';
$strBzip = '"bzip"';

$strCSVOptions = 'CSV nustatymai';
$strCannotLogin = 'Neprisijungia prie MySQL serverio';
$strCantLoad = 'negalima ?krauti %s pl?tinio,<br />pasitikrinkite php konfig?racij?';
$strCantLoadMySQL = 'negali u?krauti MySQL proceso,<br />patikrinkite PHP nustatymus.';
$strCantLoadRecodeIconv = 'Nepavyko u?krauti <em>iconv</em> arba <em>recode</em> pl?tini?, reikaling? koduot?s kovertavimui. Suteikite PHP teises naudotis ?iais i?pl?timais arba i?junkite phpMyAdmin koduot?s konvertavim?. ';
$strCantRenameIdxToPrimary = 'Indeks? pervadinti PIRMINIU nepavyko!';
$strCantUseRecodeIconv = 'Kraunant pl?tini? prane?imus, nepavyko pasinaudoti <em>iconv</em> arba <em>libiconv</em> arba <em>recode_string</em> funkcijomis. Pasitkrinkite PHP konfig?racij?. ';
$strCardinality = 'Element? skai?ius';
$strCarriage = 'Gr??imo ? eilut?s prad?i? simbolis(CR): \\r';
$strChange = 'Redaguoti';
$strChangeCopyMode = 'Sukurti nauj? vartotoj? su tom pa?iom privilegijom ir ...';  
$strChangeCopyModeCopy = '... palikti sen? vartotoj?.';  
$strChangeCopyModeDeleteAndReload = ' ... pa?alinti sen? vartotoj? i? vartotoj? lentel?s ir poto perkrauti privilegijas';  
$strChangeCopyModeJustDelete = ' ... pa?alinti sen? vartotoj? i? vartotoj? lentel?s.';  
$strChangeCopyModeRevoke = ' ... panaikinti visas privilegijas i? seno vartotojo ir poto j? pa?alinti.';  
$strChangeCopyUser = 'Pakeisti prisijungimo informacij? / Kopijuoti vartotojo duomenis';  
$strChangeDisplay = 'Pasirinkite lauk?, kur? norite per?i?r?ti';
$strChangePassword = 'Pakeisti slapta?od?';
$strCharset = 'Koduot?';
$strCharsetOfFile = 'Simboli? koduot? byloje:';
$strCheckAll = 'Pa?ym?ti visk?';
$strCheckDbPriv = 'Pa?ym?ti duomen? baz?s privilegijas';
$strCheckPrivs = 'Patikrinti privilegijas';
$strCheckPrivsLong = 'Patikrinti duombaz?s &quot;%s&quot; privilegijas.';
$strCheckTable = 'Patikrinti lentel?';
$strChoosePage = 'Pasirinkite puslap? redagavimui';
$strColComFeat = 'Stulpeli? komentar? i?vedimas';
$strColumn = 'Stulpelis';
$strColumnNames = 'Stulpeli? vardai';
$strColumnPrivileges = 'Specifin?s stulpeli? privilegijos';
$strCommand = 'Komanda';
$strComments = 'Komentarai';
$strCompleteInserts = 'Visi?kas ?terpimas';
$strCompression = 'Kompresija';
$strConfigFileError = 'phpMyAdmin negal?jo perskaityti konfig?racin?s bylos!<br />Tai gal?jo nutikti jeigu <u>php</u> rado byloje vykdymo klaid? arba visai nerando bylos.<br />Pra?ome kreiptis ? konfig?racin? byl? tiesiogiai (naudojantis nuoroda ?emiau) ir perskaityti gautus <u>php</u> klaid? prane?im?(us). Daugeliu atveju vienoje/keletoje eilu?i? truksta kabu?i? ir/arba kabliata?kio.<br />Jeigu i?vedamas tu??ias nar?ykl?s langas - viskas tvarkoje (klaid? nepasteb?ta).';
$strConfigureTableCoord = 'Nustatykite lentel?s %s koordinates';
$strConfirm = 'Ar TIKRAI norite atlikti ?? veiksm??';
$strConnections = 'Prisijungimai';
$strCookiesRequired = 'Sausain?liai(Cookies) turi b?ti priimami.';
$strCopyTable = 'Kopijuoti lentel? ? (duomen? baz?<b>.</b>lentel?):';
$strCopyTableOK = 'Letel? %s nukopijuota ? %s.';
$strCopyTableSameNames = 'Negalima kopijuoti lentel?s ? j? pa?i?!';
$strCouldNotKill = 'phpMyAdmin negal?jo i?jungti %s proceso. Gali b?ti jog jis jau u?baig? darb?.';
$strCreate = 'Sukurti';
$strCreateIndex = 'Sukurti indeks? &nbsp;%s&nbsp;stulpeliui(iams)';
$strCreateIndexTopic = 'Sukurti nauj? indeks?';
$strCreateNewDatabase = 'Sukurti nauj? duomen? baz?';
$strCreateNewTable = 'Sukurti nauj? lentel? duomen? baz?je %s';
$strCreatePage = 'Sukurti nauj? puslap?';
$strCreatePdfFeat = 'PDF bylos generavimas';
$strCriteria = 'Kriterijai';

$strDBComment = 'Duombaz?s komantaras: ';
$strDBGContext = 'Kontekstas';
$strDBGContextID = 'Konteksto ID';
$strDBGHits = 'U?klausos';
$strDBGLine = 'Eilut?';
$strDBGMaxTimeMs = 'Max laikas, ms';
$strDBGMinTimeMs = 'Min laikas, ms';
$strDBGModule = 'Modulis';
$strDBGTimePerHitMs = 'Laikas/U?klausa, ms';
$strDBGTotalTimeMs = 'Pilnas laikas, ms';
$strData = 'Duomenys';
$strDataDict = 'Duomen? ?odynas';
$strDataOnly = 'Tik duomenys';
$strDatabase = 'Duombaz? ';
$strDatabaseHasBeenDropped = 'Duomen? baz? %s i?trinta.';
$strDatabaseWildcard = 'Duomen? baz? (galima naudoti pakaitos simbolius):';
$strDatabases = 'duombaz?s';
$strDatabasesDropped = 'S?kmingai pa?alintos %s duombaz?s.';
$strDatabasesStats = 'Duomen? bazi? statistika';
$strDatabasesStatsDisable = 'Leisti statistik?';
$strDatabasesStatsEnable = 'Neleisti statistikos';
$strDatabasesStatsHeavyTraffic = 'Pastaba: Apkrovimas tarp webserverio ir MySQL gali padid?ti auk??iau normos, jeigu leisite duombaz?s statistik?.';
$strDbPrivileges = 'Specifin?s duomen? bazi? privilegijos';
$strDbSpecific = 'priklausantis nuo duomen? baz?s tipo';  
$strDefault = 'Nutylint';
$strDefaultValueHelp = 'Nenaudokite i?skyrimo simboli? ar kabu?iu, nurodydami reik?m? pagal nutyl?jim?. Naudokit?s ?iuo formatu: a';
$strDelOld = '?is puslapis turi nuorod? ? lenteles, kurios jau neegzistuoja. Ar norite pa?alinti ?ias nuorodas?';
$strDelete = 'Trinti';
$strDeleteAndFlush = 'pa?alinti vartotojus ir perkrauti privilegijas.';
$strDeleteAndFlushDescr = 'Tai yra ?variausias b?das, bet privilegij? perkrovimas gali ?iek tiek u?trukti.';
$strDeleteFailed = 'Trynimo klaida!';
$strDeleteUserMessage = 'J?s i?tyn?te vartotoj? %s.';
$strDeleted = 'Eilut? i?trinta';
$strDeletedRows = 'Eilut?s i?trintos:';
$strDeleting = '?aliname: %s';
$strDescending = 'Ma??jimo tvarka';
$strDisabled = 'I?jungta';
$strDisplay = 'Atvaizduoti';
$strDisplayFeat = 'I?vedimo s?vyb?s';
$strDisplayOrder = 'Atvaizdavimo tvarka:';
$strDisplayPDF = 'Rodyti PDF vaizd?';
$strDoAQuery = 'Vykdyti "u?klaus? pagal pavyzd?" (pakaitos simbolis: "%")';
$strDoYouReally = 'Ar TIKRAI norite ';
$strDocu = '?';
$strDrop = '?alinti';
$strDropDB = 'Panaikinti duomen? baz? %s';
$strDropSelectedDatabases = 'Pa?alinti pa?ym?tas duombazes';
$strDropTable = 'Panaikinti lentel?';
$strDropUsersDb = 'Pa?alinti duomen? bazes, turin?ias tokius pa?ius vardus kaip ir vartotojai.';
$strDumpComments = '?terpti stulpeli? komentarus kaip vidinius SQL komentarus';
$strDumpSaved = 'Duomen? baz?s atvaizdis i?saugotas byloje %s.';
$strDumpXRows = 'I?vesti %s eilu?i? pradedant nuo %s eilut?s.';
$strDumpingData = 'Sukurta duomen? kopija lentelei';
$strDynamic = 'dinaminis';

$strEdit = 'Redaguoti';
$strEditPDFPages = 'Redaguoti PDF puslapius';
$strEditPrivileges = 'Redaguoti privilegijas';
$strEffective = 'Efektyvus';
$strEmpty = 'I?valyti';
$strEmptyResultSet = 'MySQL gra?ino tu??i? rezultat? rinkin? (n?ra eilu?i?).';
$strEnabled = '?jungta';
$strEnd = 'Pabaiga';
$strEndCut = 'KIRPIMO PABAIGA';
$strEndRaw = 'RAW PABAIGA';
$strEnglishPrivileges = ' Pastaba: MySQL privilegij? pavadinimai pateikiami angl? kalba';
$strError = 'Klaida';
$strExplain = 'Paai?kinti';
$strExport = 'Eksportuoti';
$strExportToXML = 'I?vesti XML formatu';
$strExtendedInserts = 'I?pl?stinis ?terpimas';
$strExtra = 'Papildomai';

$strFailedAttempts = 'Nepavyk? bandymai';
$strField = 'Laukas';
$strFieldHasBeenDropped = 'Laukas %s i?mestas';
$strFields = 'Lauk?';
$strFieldsEmpty = ' Tu??ia lauk? skai?iaus reik?m?! ';
$strFieldsEnclosedBy = 'Lauk? reik?m?s apskliaustos  simboliais';
$strFieldsEscapedBy = 'Lauk? reik?m?s baigiasi simboliu';
$strFieldsTerminatedBy = 'Lauk? pabaigos ?ym?';
$strFileAlreadyExists = 'Byla pavadinimu %s jau yra serveryje, pakeiskite norim? pavadinim? arba pasirinkite nustatym? leid?iant? perra?yti esan?ias bylas.';
$strFileCouldNotBeRead = 'Negalima perskaityti bylos';
$strFileNameTemplate = 'Failo pavadinimo ?ablonas';
$strFileNameTemplateHelp = 'Naudokite __DB__ duomen? baz?s pavadinimui, __TABLE__ lentel?s pavadinimui ir funkcijos %sstrftime%s nustatymus laiko formatui. I?pl?timas bus pridedamas automati?kai. Kitas tekstas bus atvaizduotas kaip ?vesta.';
$strFileNameTemplateRemember = 'atsiminti ?ablon?';
$strFixed = 'fiksuotas';
$strFlushPrivilegesNote = 'Pastaba: phpMyAdmin gauna vartotoj? teises tiesiai i? MySQL privilegij? lentel?s. ?iose lentel?se nurodytos teis?s gali skirtis nuo konfig?racin?se bylose nurodyt? teisi?. Tod?l %sperkraukite teises%s, jeigu norite t?sti. ';
$strFlushTable = 'I?valyti lentel? ("FLUSH")';
$strFormEmpty = 'Tr?ksta reik?m?s formoje !';
$strFormat = 'Formatas';
$strFullText = 'Tekstus rodyti pilnai';
$strFunction = 'Funkcija';

$strGenBy = 'Generavo:';
$strGenTime = 'Atlikimo laikas';
$strGeneralRelationFeat = 'Pagrindin?s s?ry?i? s?vyb?s';
$strGlobal = 'globalus';  
$strGlobalPrivileges = 'Globalios teis?s';
$strGlobalValue = 'Globali reik?m?';
$strGo = 'Vykdyti';
$strGrantOption = 'Suteikti';
$strGrants = 'Leisti';
$strGzip = '"gzipped"';

$strHasBeenAltered = 'i?pl?sta.';
$strHasBeenCreated = 'sukurta.';
$strHaveToShow = 'Pasirinkite bent vien? stulpel? i?vedimui';
$strHome = 'Pradinis';
$strHomepageOfficial = 'Oficialus phpMyAdmin tinklapis';
$strHomepageSourceforge = 'Parsisi?sti phpMyAdmin i? Sourceforge tinklapio';
$strHost = 'Serveris';
$strHostEmpty = 'Tu??ias prisijungimo adresas!';

$strId = 'ID';
$strIdxFulltext = 'Fulltext';
$strIfYouWish = 'Jei pageidaujate pakrauti kelet? lentel?s stulpeli?, sudarykite lauk? s?ra?? atskirt? kabliata?kiais.';
$strIgnore = 'Ignoruoti';
$strIgnoringFile = 'Ignoruojama byla %s';
$strImportDocSQL = 'Importuoti docSQL bylas';
$strImportFiles = 'Importuoti bylas';
$strImportFinished = 'Importavimas baigtas';
$strInUse = '?iuo metu naudojama';
$strIndex = 'Indeksas';
$strIndexHasBeenDropped = 'Indeksas %s panaikintas';
$strIndexName = 'Indekso vardas&nbsp;:';
$strIndexType = 'Indekso tipas&nbsp;:';
$strIndexes = 'Indeksai';
$strInnodbStat = 'InnoDB b?sena';  
$strInsecureMySQL = 'J?s? konfig?racin?je byloje yra nurodyti standartiniai nustatymai (pvz: root vartotojas be slapta?o?io). Taip sukonfiguruotas MySQL serveris yra nesaugus, bei gali b?ti atviras ?silau?imams, tod?l rekomenduojame pakeisti ?iuos nustatymus.';
$strInsert = '?terpti';
$strInsertAsNewRow = '?terpti nauj? ?ra??';
$strInsertNewRow = '?terpti nauj? eilut?';
$strInsertTextfiles = '?terpti duomenis i? tekstinio failo ? lentel?';
$strInsertedRowId = '?terptos eilut?s id:';
$strInsertedRows = '?terpt? eilu?i?:';
$strInstructions = 'Instrukcijos';
$strInvalidName = '"%s" rezervuotas ?odis, J?s negalite ?io ?od?io naudoti kaip duomen? baz?s, lentel?s arba laukelio vardo.';

$strJumpToDB = 'Per?okti ? &quot;%s&quot; duomen? baz?.';
$strJustDelete = 'tik pa?alinti vartotojus i? privilegij? lentel?s.';
$strJustDeleteDescr = 'Kol n?ra perkrautos privilegijos, &quot;pa?alinti&quot; vartotojai gali prisijungti prie serverio.';

$strKeepPass = 'Nekeisti slapta?od?io';
$strKeyname = 'Raktinis ?odis';
$strKill = 'Stabdyti proces?';

$strLaTeX = 'LaTeX';
$strLaTeXOptions = 'LaTeX nustatymai';
$strLandscape = 'Peiza?inis';
$strLength = 'Ilgis';
$strLengthSet = 'Ilgis/reik?m?s*';
$strLimitNumRows = 'Eilu?i? skai?ius puslapyje';
$strLineFeed = 'Eilut?s: \\n';
$strLines = 'Eilu?i?';
$strLinesTerminatedBy = 'Eilut?s pabaigos ?ym?';
$strLinkNotFound = 'S?ry?is nerastas';
$strLinksTo = 'S?ry?is su';
$strLocalhost = 'Lokalus serveris';
$strLocationTextfile = 'Tekstiniai SQL u?klaus? failai';
$strLogPassword = 'Slapta?odis:';
$strLogUsername = 'Vartotojo vardas:';
$strLogin = '?siregistruoti';
$strLoginInformation = 'Prisijungimo informacija';
$strLogout = 'I?siregistruoti';

$strMIME_MIMEtype = 'MIME tipai';
$strMIME_available_mime = 'Galimi MIME-tipai';
$strMIME_available_transform = 'Galimos transformacijos';
$strMIME_description = 'Paai?kinimas';
$strMIME_file = 'Bylos pavadinimas';
$strMIME_nodescription = '?i transformacija neturi paai?kinimo.<br />Klauskite autoriaus k? %s daro.';
$strMIME_transformation = 'Nar?ykl?s transformacija';
$strMIME_transformation_note = 'Nor?dami gauti piln? s?ra?? galim? transformacij? ir j? MIME tip? transformacij?, spauskite %stransformacijos paai?kinim?%s';
$strMIME_transformation_options = 'Transformacijos nustatymai';
$strMIME_transformation_options_note = 'Pra?ome ?vesti transformacijos nustatym? reik?mes naudodami tok? ?vedimo format?: \'a\',\'b\',\'c\'...<br />Jeigu tarp ?i? reik?mi? prisireiks panaudoti vir?utin? vertikal? pasvir? br?k?n? ("\") arba viengub? kabut? ("\'"), naudokite vir?utin? vertikal? pasvir? br?k?n? prie? ?iuos simbolius (pvz: \'\\\\xyz\' ar \'a\\\'b\').';
$strMIME_without = 'MIME tipai atspausdinti pasvirusiu ?riftu neturi atskir? transformacijos funkcijos.';
$strMissingBracket = 'Tr?ksta skliausto(?)';
$strModifications = 'Pakeitimai i?saugoti';
$strModify = 'Keisti';
$strModifyIndexTopic = 'Keisti indeks?';
$strMoreStatusVars = 'Daugiau b?senos kintam?j?';
$strMoveTable = 'Perkelti lentel? ? (duomen? baz?<b>.</b>lentel?):';
$strMoveTableOK = 'Lentel? %s perkelta ? %s.';
$strMoveTableSameNames = 'Negalima perkelti lentel?s ? j? pa?i?!';
$strMustSelectFile = 'Pasirinkite byl?, kuri? norite ?terpti.';
$strMySQLCharset = 'MySQL koduot?';
$strMySQLReloaded = 'MySQL procesas perkrautas.';
$strMySQLSaid = 'MySQL atsakymas: ';
$strMySQLServerProcess = 'MySQL %pma_s1% procesas serveryje %pma_s2%. ?registruotas vartotojas %pma_s3%';
$strMySQLShowProcess = 'Rodyti procesus';
$strMySQLShowStatus = 'Rodyti MySQL aplinkos b?sen?';
$strMySQLShowVars = 'Rodyti MySQL sistemos kintamuosius';

$strName = 'Pavadinimas';
$strNext = 'Sekantis';
$strNo = 'Ne';
$strNoDatabases = 'N?ra duomen? bazi?';
$strNoDatabasesSelected = 'Nepa?ym?jote duombaz?s.';
$strNoDescription = 'Apra?ymo n?ra';
$strNoDropDatabases = '"DROP DATABASE" komandos ?vykdyti negalima.';
$strNoExplain = 'Praleisti SQL u?klausos ai?kinim?';
$strNoFrames = 'phpMyAdmin draugi?kesnis su <b>r?melius</b> palaikan?iomis nar?ykl?mis.';
$strNoIndex = 'Neapra?yti indeksai!';
$strNoIndexPartsDefined = 'Neapra?ytos indekso dalys!';
$strNoModification = 'N?ra pakeitim?';
$strNoOptions = '?is formatas neturi nustatym?';
$strNoPassword = 'N?ra slapta?od?io';
$strNoPermission = 'N?ra teisi? i?saugoti bylai %s.';
$strNoPhp = 'be PHP kodo';
$strNoPrivileges = 'N?ra privilegij?';
$strNoQuery = 'N?ra SQL u?klausos!';
$strNoRights = 'Neturite pakankamai teisi?';
$strNoSpace = 'N?ra pakankamai vietos i?saugoti bylai %s.';
$strNoTablesFound = 'Duomen? baz?je nerasta lenteli?.';
$strNoUsersFound = 'Nerasta vartotojo(?).';
$strNoUsersSelected = 'Nepasirinkote vartotojo.';
$strNoValidateSQL = 'Praleisti SQL u?klausos tikrinim?';
$strNone = 'N?ra';
$strNotNumber = '?veskite skai?i?!';
$strNotOK = 'Negerai';
$strNotSet = 'Lentel? <b>%s</b> nerasta arba nenurodyta %s byloje';
$strNotValidNumber = ' netinkamas eilut?s numeris!';
$strNull = 'Null';
$strNumSearchResultsInTable = '%s atitikmuo(enys) lentel?je <i>%s</i>';
$strNumSearchResultsTotal = '<b>Viso:</b> <i>%s</i> atitikmuo(enys)';
$strNumTables = 'Lentel?s';

$strOK = 'Gerai';
$strOftenQuotation = 'Da?nai kartojasi kabut?s. Pasirinktinai rei?kia, kad tik  char ir varchar laukai yra u?daryti kabut?mis.';
$strOperations = 'Veiksmai';
$strOptimizeTable = 'Optimizuoti';
$strOptionalControls = 'Pasirinktinai. Kontroliuojama kaip skaitoma, ra?oma specialiuosius simbolius.';
$strOptionally = 'Pasirinktinai';
$strOptions = 'Parinktys';
$strOr = 'Arba';
$strOverhead = 'Perteklius';
$strOverwriteExisting = 'Perra?yti esan?ias bylas';

$strPHP40203 = 'J?s naudojate PHP 4.2.3 versij?, kurioje yra rimta klaida, susiijusi su daugiabai?iais stringais (mbstring). Daugiau informacijos rasite PHP klaid? prane?ime Nr.19404. <strong>NEREKOMENDUOJAME naudoti ?ios PHP versijos su phpMyAdmin</strong>.';
$strPHPVersion = 'PHP versija';
$strPageNumber = 'Puslapis:';
$strPartialText = 'Tekstus rodyti dalinai';
$strPassword = 'Slapta?odis';
$strPasswordChanged = 'Vartotojo %s slapta?odis s?kmingai pakeistas.';
$strPasswordEmpty = 'Tu??ias slapta?odis!';
$strPasswordNotSame = 'Slapta?od?iai nesutampa!';
$strPdfDbSchema = 'Duomen? baz?s "%s" schema - %s puslapis';
$strPdfInvalidPageNum = 'Nenurodytas PDF puslapio numeris!';
$strPdfInvalidTblName = 'Lentel? "%s" neegzistuoja!';
$strPdfNoTables = 'No tables';
$strPerHour = 'per valand?';
$strPerMinute = 'per minut?';
$strPerSecond = 'per sekund?';
$strPhp = 'PHP kodas';
$strPmaDocumentation = 'phpMyAdmin\'o dokumentacija';
$strPmaUriError = 'Reikia konfig?raciniame faile ?ra?yti <tt>$cfg[\'PmaAbsoluteUri\']</tt> reik?m?!';
$strPortrait = 'Portretinis';
$strPos1 = 'Prad?ia';
$strPrevious = 'Pra?j?s';
$strPrimary = 'Pirminis';
$strPrimaryKey = 'Pirminis raktas';
$strPrimaryKeyHasBeenDropped = 'Panaikintas pirminis raktas';
$strPrimaryKeyName = 'Pirminio rakto pavadinimas turi b?ti "PRIMARY"!';
$strPrimaryKeyWarning = '("PRIMARY" <b>yra vienintelis</b> pirminio rakto tipas!)';
$strPrint = 'Spausdinti';
$strPrintView = 'Spausdinti strukt?r?';
$strPrivDescAllPrivileges = '?traukti visas teises, i?skyrus GRANT.';
$strPrivDescAlter = 'Leisti keisti jau egzistuojan?i? leneteli? strukt?r?.';
$strPrivDescCreateDb = 'Leisti kurti naujas duomen? bazes ir lenteles.';
$strPrivDescCreateTbl = 'Leisti kurti naujas lenteles.';
$strPrivDescCreateTmpTable = 'Leisti kurti laikinas lenteles.';
$strPrivDescDelete = 'Leisti ?alinti duomenis.';
$strPrivDescDropDb = 'Leisti trinti duomen? bazes ir lenteles.';
$strPrivDescDropTbl = 'Leisti trinti lenteles.';
$strPrivDescExecute = 'Leisti vykdyti i?saugotas proced?ras; Negalioja ?ioje MySQL versijoje.';
$strPrivDescFile = 'Leisti ?terpti ir eksportuoti duomenis i? byl?.';
$strPrivDescGrant = 'Leisti ?terpti naujus vartotojus, bei prisikirti privilegijas, neperkraunant privilegij? lentel?s.';
$strPrivDescIndex = 'Leisti ?terpti ir modifikuoti indeksus.';
$strPrivDescInsert = 'Leisti ?terpti ir modifikuoti duomenis.';
$strPrivDescLockTables = 'Leisti u?rakinti lenteles proces? metu.';
$strPrivDescMaxConnections = 'Riboti prisijungim? kiek? per valand?.';
$strPrivDescMaxQuestions = 'Riboti u?klaus? kiek? per valand?';
$strPrivDescMaxUpdates = 'Riboti komand? (kurios vienaip ar kitaip modifikuoja lenteles ar duomen? bazes) kiek? per valand?.';
$strPrivDescProcess3 = 'Leisti i?jungti kit? vartotoj? procesus.';
$strPrivDescProcess4 = 'Leisti per?i?r?ti proces? s?ra?e piln? u?klaus? s?ra??.';
$strPrivDescReferences = ' Negalioja ?ioje MySQL versijoje.';
$strPrivDescReload = 'Leisti perkrauti server?, bei i?valyti serverio laikin?j? atmint? (cache).';
$strPrivDescReplClient = 'Leisti vartotojo u?klausas d?l atstatymo master / slave serveri?.';
$strPrivDescReplSlave = 'Reikalinga atstatymo slave serveriui';
$strPrivDescSelect = 'Leisti skaityti duomenis.';
$strPrivDescShowDb = 'Suteikti prieig? prie vis? duomen? bazi?.';
$strPrivDescShutdown = 'Leisti i?jungti server?.';
$strPrivDescSuper = 'Leisti prisijungti, kai vir?ytas prisijungim? kiekis; Reikalinga daugumai administratoriaus darb?, toki? kaip globali? reik?mi? modifikavimui ar vartotoj? atjungimui.';
$strPrivDescUpdate = 'Leisti modifikuoti duomenis.';
$strPrivDescUsage = 'Be teisi?.';
$strPrivileges = 'Privilegijos';
$strPrivilegesReloaded = 'Teis?s s?kmingai perkrautos.';
$strProcesslist = 'Proces? s?ra?as';
$strProperties = 'Nustatymai';
$strPutColNames = 'Stulpeli? pavadinimus ?ra?yti pirmoje eilut?je';

$strQBE = 'SQL&nbsp;u?klausa';
$strQBEDel = 'Pakei?iant';
$strQBEIns = '?terpiant';
$strQueryFrame = 'U?klaus? langas';
$strQueryFrameDebug = 'Klaid? tikrinimo informacija';
$strQueryFrameDebugBox = 'Aktyv?s u?klaus? formos kintamieji:\nDuombaz?: %s\nLentel?: %s\nStotis: %s\n\nDabar naudojami u?klaus? formos kintamieji:\nDuombaz?: %s\nLentel?: %s\nStotis: %s\n\nAtidariusio lango adresas: %s\nFreimseto adresas: %s.';
$strQueryOnDb = 'SQL-u?klausa duomen? baz?je <b>%s</b>:';
$strQuerySQLHistory = 'SQL u?klaus? istorija';
$strQueryStatistics = '<b>U?klaus? statistika</b>: nuo paleidimo dienos buvo i?si?sta %s u?klaus? ? server?.';
$strQueryTime = 'U?klausa u?truko %01.4f sek.';
$strQueryType = 'U?klausos tipas';

$strReType = '?veskite dar kart?';
$strReceived = 'Gauta';
$strRecords = 'Viso ?ra??:';
$strReferentialIntegrity = 'Patikrinti s?ry?i? vientisum?:';
$strRelationNotWorking = 'N?ra PMA lenteli?, kurios leid?ia dirbti su jungtin?mis MySQL lentel?mis. %sPaai?kinimas%s.';
$strRelationView = 'Per?i?r?ti s?ry?ius';
$strRelationalSchema = 'Ry?i? schema';
$strRelations = 'S?ry?iai';
$strReloadFailed = 'MySQL proces? perkrauti nepavyko.';
$strReloadMySQL = 'Perkrauti MySQL proces?';
$strReloadingThePrivileges = 'Perkraunamos privilegijos';
$strRememberReload = 'Neu?mir?kite perkrauti server?.';
$strRemoveSelectedUsers = 'Pa?alinti pa?ym?tus vartotojus';
$strRenameTable = 'Pervadinti lentel? ?';
$strRenameTableOK = 'Lentel? %s pervadinta ? %s';
$strRepairTable = 'Redaguoti';
$strReplace = 'Pakeisti';
$strReplaceTable = 'Pakeisti lentel?s turin? failo duomenimis ';
$strReset = 'Atstatyti ? pradin? b?sen?';
$strResourceLimits = 'I?tekli? apribojimai';
$strRevoke = 'Panaikinti';
$strRevokeAndDelete = 'Panaikinti visas aktyvias vartotoj? privilegijas ir pa?alinti vartotojus.';
$strRevokeAndDeleteDescr = 'Kol n?ra perkrautos privilegijos, vartotojai dar tur?s privilegij? USAGE.';
$strRevokeGrant = 'Panaikinti GRANT privilegij?';
$strRevokeGrantMessage = 'J?s panaikinote GRANT privilegij? %s';
$strRevokeMessage = 'J?s panaikinote privilegijas %s';
$strRevokePriv = 'Panaikinti privilegijas';
$strRowLength = 'Eilut?s ilgis';
$strRowSize = 'Eilut?s dydis';
$strRows = 'Eilut?s';
$strRowsFrom = 'eilu?i? pradedant nuo';
$strRowsModeFlippedHorizontal = 'horizontal?s (pasukti pavadinimai)';
$strRowsModeHorizontal = 'horizontaliai';
$strRowsModeOptions = 'i?d?stant  %s pakartoti antra?tes kas %s ?ra??';
$strRowsModeVertical = 'vertikaliai';
$strRowsStatistic = 'Eilu?i? statistika';
$strRunQuery = 'Vykdyti u?klaus?';
$strRunSQLQuery = 'Vykdyti SQL sakinius duomen? baz?je <strong>%s</strong>';
$strRunning = 'adresu %s';

$strSQL = 'SQL';
$strSQLOptions = 'SQL nustatymai';
$strSQLParserBugMessage = 'Klaid? SQL interpretatoriuje. Pra?ome patikrinti  ar SQL u?klausoje teisingai naudojamos kabut?s. Kita, galima klaida, jog J?s bandote atsi?sti dvejetainius (binary) duomenis neapskliaustus kabut?mis. Taip pat J?s galite pabandyti ?vykdyti savo u?klaus? i? MySQL konsol?s. MySQL serverio i?vesta informacija apie klaid? (jeigu toki? bus) gali pad?ti Jums nustatyti klaidos prie?ast?. Jeigu u?klausa s?kmingai ?vykdoma konsol?je, o SQL interpretatorius vistiek i?veda prane?imus apie klaidas, pra?ome supaprastinite savo SQL u?klaus? ir perduodam? duomen? kiek? u?klausoje ir prane?kite apie klaid? programos k?r?jams su ?emiau pateikiama informacija:';
$strSQLParserUserError = 'Klaida SQL u?klausoje. ?emiau i?vestas MySQL serverio prane?imas (jeigu toks yra), tur?t? pad?ti Jums nustatyti klaidos prie?ast?';
$strSQLQuery = 'SQL u?klausa';
$strSQLResult = 'SQL rezultatas';
$strSQPBugInvalidIdentifer = 'Klaidingas vardas';
$strSQPBugUnclosedQuote = 'Tr?ksta u?daromosios kabut?s';
$strSQPBugUnknownPunctuation = 'Klaidinga skyryba';
$strSave = 'I?saugoti';
$strSaveOnServer = 'I?saugoti serveryje, kataloge pavadinimu %s';
$strScaleFactorSmall = 'Dyd?io matas yra per ma?as norint sutalpinti vaizd? viename lape.';
$strSearch = 'Paie?ka';
$strSearchFormTitle = 'Paie?ka duomen? baz?je';
$strSearchInTables = 'Lentel?s(i?) viduje:';
$strSearchNeedle = 'Paie?kos ?odis(iai) arba reik?m?(?s) (pakaitos simbolis: "%"):';
$strSearchOption1 = 'bent vienas i? ?od?i?';
$strSearchOption2 = 'visi ?od?iai';
$strSearchOption3 = 'i?tisa fraz?';
$strSearchOption4 = 'kaip reguliar?j? i?sirei?kim?';
$strSearchResultsFor = 'Paie?kos rezultatai frazei "<i>%s</i>" %s:';
$strSearchType = 'Rasti:';
$strSelect = 'I?rinkti';
$strSelectADb = 'Pasirinkite duomen? baz?';
$strSelectAll = 'I?rinkti visas(us)';
$strSelectFields = 'Pasirinkti laukus (nors vien?)';
$strSelectNumRows = 'u?klaus? vykdoma';
$strSelectTables = 'Pasirinkite lenteles';
$strSend = 'I?saugoti ? fail?';
$strSent = 'Si?sta';
$strServer = 'Serveris %s';
$strServerChoice = 'Pasirinkti server?';
$strServerStatus = 'Veikimo informacija';
$strServerStatusUptime = 'MySQL serverio veikimo trukm?: %s. Serveris prad?jo veikti: %s.';
$strServerTabProcesslist = 'Procesai';
$strServerTabVariables = 'Kintamieji';
$strServerTrafficNotes = '<b>Serverio apkrovimas</b>: ?iose lentel?se saugoma statistin? informacija apie MySQL serverio apkrovim? nuo paleidimo dienos.';
$strServerVars = 'Serverio kintamieji ir nustatymai';
$strServerVersion = 'Serverio versija';
$strSessionValue = 'Sesijos reik?m?';
$strSetEnumVal = 'Jeigu laukelio tipas yra "enum" arba "set", tuomet duomen? reik?mes reikia ?vesti naudojant ?? format?: \'a\',\'b\',\'c\'...<br />. Jeigu jums reikia ?ra?yti de?inin? ??amb?j? br?k?n? ("\") arba kabutes("\'"), tuomet prie? ?ios simbolius reikia papildomo de?ininio ??ambaus br?k?nio (pavyzd?iui: \'\\\\xyz\' or \'a\\\'b\').';
$strShow = 'Rodyti';
$strShowAll = 'Rodyti visk?';
$strShowColor = 'Rodyti spalv?';
$strShowCols = 'Rodyti stulpelius';
$strShowDatadictAs = 'Duomen? ?odyno formatas';
$strShowFullQueries = 'Rodyti pilnas u?klausas'; 
$strShowGrid = 'Rodyti tinklel?';
$strShowPHPInfo = 'Rodyti PHP informacij?';
$strShowTableDimension = 'Rodyti lenteli? dyd?ius';
$strShowTables = 'Rodyti lentel?s';
$strShowThisQuery = ' Rodyti ?i? u?klaus? v?l ';
$strShowingRecords = 'Rodomi ?ra?ai';
$strSingly = '(pavieniui)';
$strSize = 'Dydis';
$strSort = 'R??iuoti';
$strSpaceUsage = 'Vietos naudojimas';
$strSplitWordsWithSpace = '?od?iai atskirti tarpo simboliu (" ").';
$strStatCheckTime = 'Paskutinis patikrinimas';
$strStatCreateTime = 'Sukurta';
$strStatUpdateTime = 'Paskutinis atnaujinimas';
$strStatement = 'Parametrai';
$strStatus = 'Statusas';
$strStrucCSV = 'Duomenys CSV formatu';
$strStrucData = 'Strukt?ra ir duomenys';
$strStrucDrop = 'Panaikinti-?terpti lentel?';
$strStrucExcelCSV = 'Duomenys ekselio CSV formatu';
$strStrucOnly = 'Tik strukt?r?';
$strStructPropose = 'Analizuoti lentel?s strukt?r?';
$strStructure = 'Strukt?ra';
$strSubmit = 'Si?sti';
$strSuccess = 'J?s? SQL u?klausa s?kmingai ?vykdyta';
$strSum = 'Sumos';
$strSwitchToTable = 'Pereiti ? lentel?s kopij?';

$strTable = 'Lentel?';
$strTableComments = 'Lentel?s komentarai';
$strTableEmpty = 'Tu??ias lentel?s vardas!';
$strTableHasBeenDropped = 'Lentel? %s panaikinta';
$strTableHasBeenEmptied = 'Lentel?s reik?m?s %s i?tu?tintos';
$strTableHasBeenFlushed = 'Lentel?s buferis  %s i?valytas';
$strTableMaintenance = 'Lentel?s diagnostika';
$strTableOfContents = 'Turinys';
$strTableStructure = 'Sukurta duomen? strukt?ra lentelei';
$strTableType = 'Lentel?s tipas';
$strTables = '%s lentel?(s)';
$strTblPrivileges = 'Specifin?s lenteli? privilegijos';
$strTextAreaLength = ' Tai yra jo ilgis,<br /> ?is laukelis neredaguojamas ';
$strTheContent = 'J?s? failo turinys ?terptas.';
$strTheContents = 'Failo turinys ?terpus panaikina i?rinktos lentel?s ar stulpelio turin?, bet i?lieka unikal?s ir pirminiai indeksai.';
$strTheTerminator = 'Lauk? pabaigos ?ym?.';
$strThisHost = 'Dabartinis serveris';
$strThisNotDirectory = 'Tai ne katalogas';
$strThreadSuccessfullyKilled = '%s buvo s?kmingai i?jungtas.';
$strTime = 'Laikas';
$strTotal = ' i? viso ';
$strTotalUC = 'Viso';
$strTraffic = 'Apkrovimas';
$strTransformation_image_jpeg__inline = 'Parodo aktyv? ma?in?; nustatymai: plotis,auk?tis pikseliais (i?saugo original? santyk?)';  
$strTransformation_image_jpeg__link = 'I?vedama nuoroda ? ?? paveiksl?l? (tiesioginis blob atsisiuntimas ir pan.).';
$strTransformation_image_png__inline = '?r. image/jpeg: vid?';  
$strTransformation_text_plain__dateformat = 'Pasiima TIME, TIMESTAMP arba DATETIME lauk? reik?mes ir apipavidalina jas pagal naudojam? lokal? datos format?. Pirmas parametras reik?m? valandomis, kuri bus prid?ta prie laiko ?ym?s (nutylint: 0). Antras parametras tai kitoks datos apipavidalinimo formatas pateiktas pagal strftime() fukcij?.';
$strTransformation_text_plain__external = 'LINUX VARTOTOJAMS: Paleid?iama i?orin? aplikacija ir duomenys imami i? standartinio ?vedimo. I?vedama i? aplikacijos gauta informacija. Nutylint: bus Tidy korekti?kam HTML kodo i?vedimui. Saugumo sumetimais J?s turite paredaguoti libraries/transformations/text_plain__external.inc.php byl? ir ?vesti tas aplikacijas, kurias naudosite. Pirmas parametras yra leid?iam? aplikacij? kiekis, kurias naudosite. Antras parametras yra specifiniai aplikacij? raktai. Jeigu tre?ias parametras lygus 1, tai i?vedama informacija bus apdorota su htmlspecialchars() (nutylint: reik?m? lygi 1). Jeigu ketvirtas parametras lygus 1, tai i?vedimo lentel?s cel? tur?s atribut? NOWRAP, tam kad i?vedama b?t? atvaizduota be perk?lim? ? kitas eilutes (nutylint: reik?m? lygi 1).';
$strTransformation_text_plain__formatted = 'I?saugo original? lauko apipavidalinim?. Nevykdomas i?vengimas.';
$strTransformation_text_plain__imagelink = 'Gra?inamas paveiksl?lis ir nuoroda ? ?vedimo lauke ?ra?yt? bylos pavadinim?; argumentai: prefiksas (pvz "http://domain.com/"), plotis (pikseliais), auk?tis (pikseliais).';
$strTransformation_text_plain__link = 'Gra?inama nuoroda ? ?vedimo lauke ?ra?yt? bylos pavadinim?; argumentai: prefiksas (pvz "http://domain.com/"), nuorodos pavadinimas.';
$strTransformation_text_plain__substr = 'Rodoma tik dalis teksto. Pirmas parametras nurodo i?vedamo teksto prad?i? (nutylint: 0). Antrasis parametras nurodo i?vedamo teksto kiek?. Jeigu antras parametras nenurodytas tai bus i?vestas visas tekstas. Tre?iasis parametras nurodo kurios raid?s bus prijungtos prie i?vedimo teksto (nutylint: ...).';
$strTransformation_text_plain__unformatted = 'Rodo HTML kod? kaip HTML esybes. Nerodomas HTML apipavidalinimas.';
$strTruncateQueries = 'Trumpinti rodomas u?klausas'; 
$strType = 'Tipas';

$strUncheckAll = 'Nepa?ym?ti visus(as)';
$strUnique = 'Unikalus';
$strUnselectAll = 'Nepa?ym?ti visus(as)';
$strUpdComTab = 'Informacij?, kaip atnaujinti Column_comments lentel?, galite rasti dokumentacijoje.';  
$strUpdatePrivMessage = 'J?s pakeit?te privilegijas  %s.';
$strUpdateProfile = 'Papildyti profil?:';
$strUpdateProfileMessage = 'Profilis papildytas.';
$strUpdateQuery = 'Atnaujinti u?klaus?';
$strUsage = 'I?naudota';
$strUseBackquotes = 'Lenteli? ir lauk? vardams naudoti ?ias kabutes ` `';
$strUseHostTable = 'Naudoti Host lentel?'; 
$strUseTables = 'Naudoti lenteles';
$strUseTextField = 'Naudokite teksto ?vedimo lauk?';
$strUser = 'Vartotojas';
$strUserAlreadyExists = 'Vartotojas %s jau yra!';
$strUserEmpty = 'Tu??ias vartotojo vardas!';
$strUserName = 'Vartotojo vardas';
$strUserNotFound = 'Privilegij? lentel?je pasirinktas vartotojas nerastas.';
$strUserOverview = 'Vartotoj? per?i?ra';
$strUsers = 'Vartotojai';
$strUsersDeleted = 'Pa?ym?ti vartotojai s?kmingai pa?alinti.';
$strUsersHavingAccessToDb = 'Vartotojai turintys pri?jim? prie &quot;%s&quot;';  

$strValidateSQL = 'Patikrinti SQL u?klaus?';
$strValidatorError = 'Neveikia SQL interpretatorius. Pra?ome patikrinkite ar yra suinstaliuoti visi privalomi php moduliai, nurodyti %sdokumentacijoje%s.';
$strValue = 'Reik?m?';
$strVar = 'Kintamasis';
$strViewDump = 'Per?i?r?ti lentel?s strukt?ros atvaizd?';
$strViewDumpDB = 'Sukurti, per?i?r?ti duomen? baz?s atvaizd?';

$strWebServerUploadDirectory = 'web serverio katalogas atsiuntimams';
$strWebServerUploadDirectoryError = 'Nepasiekimas nurodytas www-serverio katalogas atsiuntimams.';
$strWelcome = 'J?s naudojate %s';
$strWildcard = 'pakaitos simbolis';  
$strWithChecked = 'Pasirinktas lenteles:';
$strWritingCommentNotPossible = 'Negalimas komentavimas';
$strWritingRelationNotPossible = 'Negalimas s?ry?is';
$strWrongUser = 'Neteisingas vartotojo vardas arba slapta?odis. Pri?jimas u?draustas.';

$strXML = 'XML';

$strYes = 'Taip';

$strZeroRemovesTheLimit = 'Pastaba: N?ra joki? apribojim? jeigu reik?m? nurodyta lygi 0 (nuliui).';
$strZip = '"zip"';
// To translate

$strLoadExplanation = 'The best method is checked by default, but you can change if it fails.';  //to translate
$strLoadMethod = 'LOAD method'; //to translate

?>
