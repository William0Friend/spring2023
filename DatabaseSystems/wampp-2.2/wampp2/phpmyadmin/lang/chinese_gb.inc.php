<?php
/* $Id: chinese_gb.inc.php,v 1.245 2003/06/01 12:33:51 lem9 Exp $ */

/**
 * Last translation by: Funda Wang <fundawang@en2china.com>
 */

$charset = 'gb2312';
$text_dir = 'ltr';
$left_font_family = 'simsun, ����';
$right_font_family = 'simsun';
$number_thousands_separator = ',';
$number_decimal_separator = '.';
// shortcuts for Byte, Kilo, Mega, Giga, Tera, Peta, Exa
$byteUnits = array('�ֽ�', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB');

$day_of_week = array('����', '��һ', '�ܶ�', '����', '����', '����', '����');
$month = array('һ��', '����', '����', '����', '����', '����', '����', '����', '����', 'ʮ��', 'ʮһ��', 'ʮ����');
// See http://www.php.net/manual/en/function.strftime.php to define the
// variable below
$datefmt = '%Y �� %m �� %d �� %H:%M';

$timespanfmt = '%s �� %s Сʱ, %s �� %s ��';

$strAbortedClients = '��ֹ';
$strAbsolutePathToDocSqlDir = '������ docSQL Ŀ¼�� Web �������ľ���·��';
$strAccessDenied = '���ʱ��ܾ�';
$strAction = '����';
$strAddDeleteColumn = '����/ɾ���ֶ���';
$strAddDeleteRow = '����/ɾ��������';
$strAddedColumnComment = '��������ע��';
$strAddedColumnRelation = '�������й�ϵ';
$strAddNewField = '�������ֶ�';
$strAddPriv = '������Ȩ��';
$strAddPrivilegesOnDb = '���������ݿ�����Ȩ��';
$strAddPrivilegesOnTbl = '�����б�����Ȩ��';
$strAddPrivMessage = '���Ѿ���������Ȩ�ޡ�';
$strAddSearchConditions = '������������(��where����������)��';
$strAddToIndex = '���ӵ� &nbsp;%s&nbsp; ��';
$strAddUser = '�������û�';
$strAddUserMessage = '����������һ�����û���';
$strAdministration = '����';
$strAffectedRows = 'Ӱ������:';
$strAfter = '�� %s ֮��';
$strAfterInsertBack = '���˵���һҳ';
$strAfterInsertNewInsert = '�����µ�һ��';
$strAll = 'ȫ��';
$strAllTableSameWidth = '����ͬ������ʾ���б���?';
$strAlterOrderBy = '���ı�˳������';
$strAnalyzeTable = '������';
$strAnd = '��';
$strAnIndex = '�����Ѿ����ӵ� %s';
$strAny = '����';
$strAnyColumn = '������';
$strAnyDatabase = '�������ݿ�';
$strAnyHost = '��������';
$strAnyTable = '�����';
$strAnyUser = '�����û�';
$strAPrimaryKey = '�����Ѿ����ӵ� %s';
$strAscending = '����';
$strAtBeginningOfTable = '�ڱ���ͷ';
$strAtEndOfTable = '�ڱ���β';
$strAttr = '����';
$strAutodetect = '�Զ����';
$strAutomaticLayout = '�Զ����ø�ʽ';

$strBack = '����';
$strBeginCut = '��ʼ����';
$strBeginRaw = '��ʼԭ��';
$strBinary = '������';
$strBinaryDoNotEdit = '������ - �޷��༭';
$strBookmarkDeleted = '��ǩ�Ѿ�ɾ����';
$strBookmarkLabel = '��ǩ';
$strBookmarkQuery = '�Ѽ���ǩ�� SQL ��ѯ';
$strBookmarkThis = '���� SQL ��ѯ��Ϊ��ǩ';
$strBookmarkView = 'ֻ�鿴';
$strBrowse = '���';
$strBzError = 'phpMyAdmin �޷�ѹ��ת�棬ԭ���Ǵ˰汾 php �е� Bz2 ģ���𻵡�ǿ�ҽ� phpMyAdmin �����ļ��е� <code>$cfg[\'BZipDump\']</code> ����Ϊ <code>FALSE</code>���������ʹ�� Bz2 ѹ�����ܣ������ php �İ汾��������ο� php ���󱨸� %s��';
$strBzip = '"bzipped"';

$strCannotLogin = '�޷����� MySQL ������';
$strCantLoad = '�޷�װ�� %s ��չ��<br />���� PHP ����';
$strCantLoadMySQL = '�޷�װ�� MySQL ��չ��<br />���� PHP �����á�';
$strCantLoadRecodeIconv = '�޷�װ�� iconv ���߽����ַ���ת��������ر�����չ���������� php ����ʹ����Щ��չ������ phpMyAdmin �н����ַ���ת�����ܡ�';
$strCantRenameIdxToPrimary = '�޷�����������Ϊ PRIMARY!';
$strCantUseRecodeIconv = 'װ����չ����ʱ iconv, libiconv �� recode_string ���޷�ʹ�á��������� php ���á�';
$strCardinality = '����';
$strCarriage = '�س�: \\r';
$strChange = '����';
$strChangeCopyMode = '����������ͬȨ�޵����û��� ...';
$strChangeCopyModeCopy = '... �������û���';
$strChangeCopyModeDeleteAndReload = ' ... ���û�����ɾ�����û���Ȼ������װ��Ȩ�ޡ�';
$strChangeCopyModeJustDelete = ' ... ���û�����ɾ�����û���';
$strChangeCopyModeRevoke = ' ... �ջؾ��û������м���Ȩ�ޣ�Ȼ��ɾ�����û���';
$strChangeCopyUser = '���ĵ�¼��Ϣ/�����û�';
$strChangeDisplay = 'ѡ��Ҫ��ʾ���ֶ�';
$strChangePassword = '��������';
$strCharset = '�ַ���';
$strCharsetOfFile = '�ļ����ַ���:';
$strCheckAll = 'ȫѡ';
$strCheckDbPriv = '������ݿ�Ȩ��';
$strCheckPrivs = '���Ȩ��';
$strCheckPrivsLong = '������ݿ⡰%s����Ȩ�ޡ�';
$strCheckTable = '����';
$strChoosePage = '��ѡ����Ҫ�༭��ҳ��';
$strColComFeat = '��ʾ��ע��';
$strColumn = '��';
$strColumnNames = '����';
$strColumnPrivileges = '����ָ��Ȩ��';
$strCommand = '����';
$strComments = 'ע��';
$strCompleteInserts = '��������';
$strCompression = 'ѹ��';
$strConfigFileError = 'phpMyAdmin �޷���ȡ���������ļ�!<br />���������Ϊ php �������﷨����� php δ���ҵ��ĵ���<br />��ֱ��ʹ����������ӵ��������ļ���Ȼ���ȡ���յ��� php ������ʾ��ͨ���Ĵ�������Ϊĳ��©�����Ż�ֺš�<br />�������������һ���հ�ҳ�������û���κ����⡣';
$strConfigureTableCoord = '�����ñ� %s ������';
$strConfirm = '��ȷ��Ҫ������?';
$strConnections = '����';
$strCookiesRequired = 'Cookies �������ò��ܵ��롣';
$strCopyTable = '�������Ƶ�(���ݿ���<b>.</b>����):';
$strCopyTableOK = '�� %s �Ѿ��ɹ�����Ϊ %s��';
$strCopyTableSameNames = '�޷���������Ϊ��ͬ����!';
$strCouldNotKill = 'phpMyAdmin �޷�ɱ���߳� %s�����ܸ��߳��Ѿ��رա�';
$strCreate = '����';
$strCreateIndex = '�ڵ� &nbsp;%s&nbsp; �д�������';
$strCreateIndexTopic = '����������';
$strCreateNewDatabase = '����һ���µ����ݿ�';
$strCreateNewTable = '�����ݿ� %s �д���һ���±�';
$strCreatePage = '������ҳ';
$strCreatePdfFeat = '���� PDF';
$strCriteria = '����';
$strCSVOptions = 'CSV ѡ��';

$strData = '����';
$strDatabase = '���ݿ� ';
$strDatabaseHasBeenDropped = '���ݿ� %s �ѱ�ɾ����';
$strDatabases = '���ݿ�';
$strDatabasesDropped = '�Ѿ��ɹ�ɾ���� %s �����ݿ⡣';
$strDatabasesStats = '���ݿ�ͳ��';
$strDatabasesStatsDisable = '����ͳ��';
$strDatabasesStatsEnable = '����ͳ��';
$strDatabasesStatsHeavyTraffic = 'ע�⣺�ڴ��������ݿ�ͳ�ƿ��ܵ��� Web �������� MySQL ������֮�������������';
$strDatabaseWildcard = '���ݿ�(����ʹ��ͨ���):';
$strDataDict = '�����ֵ�';
$strDataOnly = 'ֻ������';
$strDBComment = '���ݿ�ע��: ';
$strDBGContext = '������';
$strDBGContextID = '������ ID';
$strDBGHits = '����';
$strDBGLine = '��';
$strDBGMaxTimeMs = '���ʱ�䣬����';
$strDBGMinTimeMs = '��Сʱ�䣬����';
$strDBGModule = 'ģ��';
$strDBGTimePerHitMs = 'ʱ��/�Σ�����';
$strDBGTotalTimeMs = '�ܼ�ʱ�䣬����';
$strDbPrivileges = '�����ݿ�ָ��Ȩ��';
$strDbSpecific = '�����ݿ�ָ��';
$strDefault = 'Ĭ��';
$strDefaultValueHelp = '����Ĭ��ֵ����ֻ���뵥��ֵ����Ҫ�ӷ�б�߻����ţ����ô˸�ʽ: a';
$strDelete = 'ɾ��';
$strDeleteAndFlush = 'ɾ���û������¶�ȡȨ�ޡ�'; 
$strDeleteAndFlushDescr = '����һ�������������������¶�ȡȨ����һ��ʱ�䡣';
$strDeleted = '�����Ѿ���ɾ����';
$strDeletedRows = '��ɾ������:';
$strDeleteFailed = 'ɾ��ʧ��!';
$strDeleteUserMessage = '���Ѿ����û� %s ɾ����';
$strDeleting = '����ɾ�� %s';
$strDelOld = '��ǰҳ�����õı��������ˡ����Ƿ���Ҫɾ����Щ����?';
$strDescending = '�ݼ�';
$strDisabled = '�ѽ���';
$strDisplay = '��ʾ';
$strDisplayFeat = '��ʾ����';
$strDisplayOrder = '��ʾ˳��';
$strDisplayPDF = '��ʾ PDF ���';
$strDoAQuery = 'ִ�С�������ѯ��(ͨ���:��%��)';
$strDocu = '�ĵ�';
$strDoYouReally = '�����Ҫ';
$strDrop = 'ɾ��';
$strDropDB = 'ɾ�����ݿ� %s';
$strDropSelectedDatabases = 'ɾ��ѡ�����ݿ�';
$strDropTable = 'ɾ����';
$strDropUsersDb = 'ɾ�����û�������ͬ�����ݿ⡣';
$strDumpComments = '����ע��дΪǶ��� SQL ע��';
$strDumpingData = '�������е�����';
$strDumpSaved = 'ת���Ѿ����浽�ļ� %s ���ˡ�';
$strDumpXRows = 'ת�� %s �У��Ӽ�¼ #%s ��ʼ��';
$strDynamic = '��̬';

$strEdit = '�༭';
$strEditPDFPages = '�༭ PDF ҳ';
$strEditPrivileges = '�༭Ȩ��';
$strEffective = '��Ч';
$strEmpty = '���';
$strEmptyResultSet = 'MySQL ���صĲ�ѯ���Ϊ��(������)��';
$strEnabled = '������';
$strEnd = '����';
$strEndCut = '��������';
$strEndRaw = '����ԭ��';
$strEnglishPrivileges = ' ע�⣺MySQL Ȩ�����ƻ���Ӣ����ʾ ';
$strError = '����';
$strExplain = '���� SQL';
$strExport = '����';
$strExportToXML = '������ XML ��ʽ';
$strExtendedInserts = '��չ����';
$strExtra = '����';

$strFailedAttempts = '����ʧ��';
$strField = '�ֶ�';
$strFieldHasBeenDropped = '�ֶ� %s �ѱ�ɾ��';
$strFields = '�ֶ���';
$strFieldsEmpty = ' �ֶ������ǿյ�! ';
$strFieldsEnclosedBy = '�����ֶε��ַ�';
$strFieldsEscapedBy = 'ת���ֶε��ַ�';
$strFieldsTerminatedBy = '�ָ��ֶε��ַ�';
$strFileAlreadyExists = '�ļ� %s �Ѿ������ڷ������ϣ�������ļ�������ѡ�и���ѡ�';
$strFileCouldNotBeRead = '�ļ��޷���ȡ';
$strFileNameTemplate = '�ļ���ģ��';
$strFileNameTemplateHelp = 'ʹ�� __DB__ �������ݿ�����__TABLE__ ����������ʹ��%s�κ� strftime%s ѡ��ָ��ʱ�䣬��չ�����Զ����ӡ��κ������ı����ᱻ������';
$strFileNameTemplateRemember = '��סģ��';
$strFixed = '�̶�';
$strFlushPrivilegesNote = 'ע�⣺phpMyAdmin ֱ���� MySQL Ȩ�ޱ�ȡ���û�Ȩ�ޡ�����û��ֶ����ı��������ݽ������������ʹ�õ��û�Ȩ�����졣����������£���Ӧ�ڼ���ǰ%s��������Ȩ��%s��';
$strFlushTable = 'ǿ�ȸ������ϱ�("FLUSH")';
$strFormat = '��ʽ';
$strFormEmpty = '������ȱ��ֵ!';
$strFullText = '��������';
$strFunction = '����';

$strGenBy = '������';
$strGeneralRelationFeat = 'һ���ϵ����';
$strGenTime = '��������';
$strGlobal = 'ȫ��';
$strGlobalPrivileges = 'ȫ��Ȩ��';
$strGlobalValue = 'ȫ��ֵ';
$strGo = 'ִ��';
$strGrantOption = '��Ȩ';
$strGrants = 'Grants'; // should expressed in English
$strGzip = '"gzipped"';

$strHasBeenAltered = '�Ѿ����޸ġ�';
$strHasBeenCreated = '�Ѿ�������';
$strHaveToShow = '����Ҫ����ѡ����ʾһ��';
$strHome = '��Ŀ¼';
$strHomepageOfficial = 'phpMyAdmin �ٷ���վ';
$strHomepageSourceforge = 'Sourceforge phpMyAdmin ����ҳ';
$strHost = '����';
$strHostEmpty = '���������ǿյ�!';

$strId = 'ID'; // use eng
$strIdxFulltext = 'ȫ������';
$strIfYouWish = '���������Ҫװ����еļ��У�������ö��ŷָ����ֶ��б���';
$strIgnore = '����';
$strIgnoringFile = '�����ļ� %s';
$strImportDocSQL = '���� docSQL �ĵ�';
$strImportFiles = '�����ļ�';
$strImportFinished = '�������';
$strIndex = '����';
$strIndexes = '����';
$strIndexHasBeenDropped = '���� %s �ѱ�ɾ��';
$strIndexName = '��������&nbsp;:';
$strIndexType = '��������&nbsp;:';
$strInnodbStat = 'InnoDB ״̬';
$strInsecureMySQL = '�������ļ��е��趨�� MySQL Ĭ��Ȩ���˻���Ӧ(û������� root)������ MySQL ������ʹ��Ĭ��ֵ���е�Ȼû�����⣬���������Ļ��������ֵĿ����Ի�ܴ������Ӧ���Ȳ��������ȫ©����';
$strInsert = '����';
$strInsertAsNewRow = '�����в���';
$strInsertedRowId = '������ id:';
$strInsertedRows = '���������:';
$strInsertNewRow = '��������';
$strInsertTextfiles = '���ı��ļ�����ȡ���ݣ����뵽��';
$strInstructions = 'ָʾ';
$strInUse = 'ʹ����';
$strInvalidName = '��%s����һ�������֣������ܽ��������������ݿ�/��/�ֶε����ơ�';

$strJumpToDB = '�������ݿ⡰%s����';
$strJustDelete = 'ֻ��Ȩ�����ݿ�ɾ���û���';
$strJustDeleteDescr = '��ɾ�������û���Ȼ��������һ���������ݿ⣬ֱ����������Ȩ�ޡ�';

$strKeepPass = '�벻Ҫ��������';
$strKeyname = '����';
$strKill = 'Kill'; //should expressed in English

$strLandscape = '����';
$strLaTeX = 'LaTeX';  // use eng
$strLaTeXOptions = 'LaTeX ѡ��';
$strLength = '����';
$strLengthSet = '����/ֵ*';
$strLimitNumRows = 'ÿҳ����';
$strLineFeed = '����: \\n';
$strLines = '����';
$strLinesTerminatedBy = '����ֹ���ַ�';
$strLinkNotFound = '�Ҳ�������';
$strLinksTo = '���ӵ�';
$strLoadMethod = 'LOAD ģʽ';
$strLoadExplanation = 'Ĭ�������ѡ�е�����õ�ģʽ���������ʧ�ܵĻ�����Ҳ���Խ��и��ġ�';
$strLocalhost = '����';
$strLocationTextfile = '�ı��ļ���λ��';
$strLogin = '����';
$strLoginInformation = '������Ϣ'; 
$strLogout = '�ǳ�';
$strLogPassword = '����:';
$strLogUsername = '��������:';

$strMIME_available_mime = '���õ� MIME ����';
$strMIME_available_transform = '���õı任';
$strMIME_description = '����';
$strMIME_file = '�ļ���';
$strMIME_MIMEtype = 'MIME ����';
$strMIME_nodescription = '�˱任�޿��õ�������<br />��ϸ������ѯ�� %s �����ߡ�';
$strMIME_transformation = '������任';
$strMIME_transformation_note = 'Ҫ��ÿ��ñ任ѡ����嵥����Ӧ�� MIME ���ͱ任���뵥��%s�任����%s';
$strMIME_transformation_options = '�任ѡ��';
$strMIME_transformation_options_note = '��ʹ�ô˸�ʽ����任ѡ���ֵ: \'a\',\'b\',\'c\'...<br />�������Ҫ��ֵ�����뷴б��(��\��)���ߵ�����(��\'��)������ǰ����Ϸ�б��(�� \'\\\\xyz\' �� \'a\\\'b\')��';
$strMIME_without = '��б���ӡ�� MIME ����û�е����ı任����';
$strMissingBracket = '�Ҳ�������';
$strModifications = '�޸��Ѿ����档';
$strModify = '�޸�';
$strModifyIndexTopic = '�޸�����';
$strMoreStatusVars = '����״̬����';
$strMoveTable = '�����ƶ���(���ݿ���<b>.</b>����):';
$strMoveTableOK = '�� %s �Ѿ��ƶ��� %s��';
$strMoveTableSameNames = '�޷������ƶ�Ϊ��ͬ����!';
$strMustSelectFile = '��Ӧ��ѡ������Ҫ������ļ���';
$strMySQLCharset = 'MySQL �ַ���';
$strMySQLReloaded = 'MySQL ����������ɡ�';
$strMySQLSaid = 'MySQL ����:';
$strMySQLServerProcess = 'MySQL %pma_s1% �� %pma_s2% �� %pma_s3% ������ִ��';
$strMySQLShowProcess = '��ʾ����';
$strMySQLShowStatus = '��ʾ MySQL ��������Ϣ';
$strMySQLShowVars = '��ʾ MySQL ��ϵͳ����';

$strName = '����';
$strNext = '��һ��';
$strNo = '��';
$strNoDatabases = '�����ݿ�';
$strNoDatabasesSelected = 'û��ѡ�����ݿ⡣';
$strNoDescription = '������';
$strNoDropDatabases = '�Ѿ����á�DROP DATABASE����䡣';
$strNoExplain = '�Թ����� SQL';
$strNoFrames = 'phpMyAdmin ���ʺ���֧��<b>���</b>���������ʹ�á�';
$strNoIndex = 'û���Ѷ��������!';
$strNoIndexPartsDefined = 'û�ж������������!';
$strNoModification = '�޸���';
$strNone = '��';
$strNoOptions = '���ָ�ʽ����ѡ��';
$strNoPassword = '������';
$strNoPermission = 'Web �����������������ļ� %s��';
$strNoPhp = '�� PHP ����';
$strNoPrivileges = '��Ȩ��';
$strNoQuery = '�� SQL ��ѯ!';
$strNoRights = '������û���㹻��Ȩ���ڴ˳���!';
$strNoSpace = 'û���㹻�Ŀռ䱣���ļ� %s��';
$strNoTablesFound = '���ݿ���û�б���';
$strNotNumber = '�ⲻ��һ������!';
$strNotOK = '����';
$strNotSet = '<b>%s</b> ���Ҳ�����δ�� %s �趨';
$strNotValidNumber = ' ������Ч������!';
$strNoUsersFound = '�Ҳ����û���';
$strNoUsersSelected = 'û��ѡ���û���';
$strNoValidateSQL = '�Թ�У�� SQL';
$strNull = 'Null';
$strNumSearchResultsInTable = '%s ��ƥ���� - �ڱ� <i>%s</i> ��';
$strNumSearchResultsTotal = '<b>�ܼ�:</b> <i>%s</i> ��ƥ����';
$strNumTables = '����';

$strOftenQuotation = 'ͨ��Ϊ���š���ѡ��ζ��ֻ�� char �� varchar ���͵��ֶβ���Ҫ�ô��ַ�����������';
$strOK = 'ȷ��';
$strOperations = '����';
$strOptimizeTable = '�Ż���';
$strOptionalControls = '��ѡ��������ζ�д�����ַ���';
$strOptionally = '��ѡ';
$strOptions = 'ѡ��';
$strOr = '��';
$strOverhead = '����';
$strOverwriteExisting = '���������ļ�';

$strPageNumber = 'ҳ��:';
$strPartialText = '��������';
$strPassword = '����';
$strPasswordChanged = '%s �������ѳɹ����ġ�';
$strPasswordEmpty = '�����ǿյ�!';
$strPasswordNotSame = '���벢����ͬ!';
$strPdfDbSchema = '��%s�����ݿ��� - �� %s ҳ';
$strPdfInvalidPageNum = 'PDF ҳ��û���趨!';
$strPdfInvalidTblName = '����%s��������!';
$strPdfNoTables = 'û�б�';
$strPerHour = 'ÿСʱ'; 
$strPerMinute = 'ÿ����';
$strPerSecond = 'ÿ��';
$strPhp = '���� PHP ����';
$strPHP40203 = '����ʹ�� PHP �汾 4.2.3���ð汾��һ��˫�ֽ��ַ�(mbstring)�����ش�������� PHP ���汨�� 19404��phpMyAdmin ��������ʹ������汾�� PHP��';
$strPHPVersion = 'PHP �汾';
$strPmaDocumentation = 'phpMyAdmin �ĵ�';
$strPmaUriError = '���������������ļ����趨 <tt>$cfg[\'PmaAbsoluteUri\']</tt> ָ��!';
$strPortrait = '����';
$strPos1 = '��ʼ';
$strPrevious = 'ǰһ��';
$strPrimary = '����';
$strPrimaryKey = '����';
$strPrimaryKeyHasBeenDropped = '�����ѱ�ɾ��';
$strPrimaryKeyName = '���������Ʊ����Ϊ PRIMARY!';
$strPrimaryKeyWarning = '(��PRIMARY��<b>����</b>�����������ƣ�������������<b>Ψһ</b>!)';
$strPrint = '��ӡ';
$strPrintView = '��ӡԤ��';
$strPrivDescAllPrivileges = '��������Ȩ�޳�����Ȩ (GRNANT)��';
$strPrivDescAlter = '�����޸����б��Ľṹ��';
$strPrivDescCreateDb = '�������������ݿ�ͱ���'; 
$strPrivDescCreateTbl = '���������±���';
$strPrivDescCreateTmpTable = '����������ʱ����';
$strPrivDescDelete = '����ɾ�����ݡ�';
$strPrivDescDropDb = '����ɾ�����ݿ�ͱ���'; 
$strPrivDescDropTbl = '����ɾ������'; 
$strPrivDescExecute = '�������д洢���̣��ڴ˰汾�� MySQL ����Ч��';
$strPrivDescFile = '�������ļ��е��������Լ������ݵ������ļ���';
$strPrivDescGrant = '���������û���Ȩ�ޣ�������������װ��Ȩ�ޱ���';
$strPrivDescIndex = '����������ɾ��������';
$strPrivDescInsert = '����������滻���ݡ�';
$strPrivDescLockTables = '������ס��ǰ�����ı���';
$strPrivDescMaxConnections = '�����û�ÿСʱ�򿪵�����������';
$strPrivDescMaxQuestions = '�����û�ÿСʱ�ɷ��͵Ĳ�ѯ����';
$strPrivDescMaxUpdates = '�����û�ÿСʱ��ִ�еĽ�������κα������ݿ����������';
$strPrivDescProcess3 = '����ɱ�������û��Ľ��̡�';
$strPrivDescProcess4 = '�����鿴�����б��е�������ѯ��';
$strPrivDescReferences = '�ڴ˰汾�� MySQL ����Ч��';
$strPrivDescReload = '��������װ����������ò����շ������Ļ��档';
$strPrivDescReplClient = '�û���Ȩѯ������/���������';
$strPrivDescReplSlave = '�ظ��������衣';
$strPrivDescSelect = '������ȡ���ݡ�';
$strPrivDescShowDb = '�����������������ݿ��б���';
$strPrivDescShutdown = '�����رշ�������';
$strPrivDescSuper = '�����ڴﵽ���������Ŀʱ�Խ������ӣ������������ȫ�ֱ�����ɱ�������û��߳������Ĺ����������衣';
$strPrivDescUpdate = '�����������ݡ�';
$strPrivDescUsage = '��Ȩ�ޡ�';
$strPrivileges = 'Ȩ��';
$strPrivilegesReloaded = 'Ȩ���Ѿ��ɹ�װ�롣';
$strProcesslist = '�����б�';
$strProperties = '����';
$strPutColNames = '���ֶ����Ʒ�������';

$strQBE = '��ѯ';
$strQBEDel = 'ɾ��';
$strQBEIns = '����';
$strQueryFrame = '��ѯ����';
$strQueryFrameDebug = '������Ϣ';
$strQueryFrameDebugBox = '��ѯ�����ļ������:\n���ݿ�: %s\n��: %s\n������: %s\n\n��ѯ�����ĵ�ǰ����:\n���ݿ�: %s\n��: %s\n������: %s\n\n��λ��: %s\n��ܼ�λ��: %s.';
$strQueryOnDb = '�����ݿ� <b>%s</b> ִ�� SQL ���:';
$strQuerySQLHistory = 'SQL ��ʷ';
$strQueryStatistics = '<b>��ѯͳ��</b>: �Դ������󣬷��������յ��� %s �β�ѯ��';
$strQueryTime = '��ѯ���� %01.4f ��';
$strQueryType = '��ѯ��ʽ';

$strReceived = '���յ�';
$strRecords = '��¼��';
$strReferentialIntegrity = '�������������:';
$strRelationalSchema = '��ϵ���';
$strRelationNotWorking = 'ʹ�����ӱ��Ķ���������δ���Ҫ���ԭ���뵥��%s�˴�%s��';
$strRelations = '��ϵ';
$strRelationView = '��ϵ�鿴';
$strReloadFailed = 'MySQL ����ʧ�ܡ�';
$strReloadingThePrivileges = '����װ��Ȩ��';
$strReloadMySQL = '���� MySQL';
$strRememberReload = '������������������';
$strRemoveSelectedUsers = 'ɾ��ѡ���û�';
$strRenameTable = '��������Ϊ';
$strRenameTableOK = '�� %s �����Ѿ����ĳ� %s��';
$strRepairTable = '�޸���';
$strReplace = '�滻';
$strReplaceTable = '�����������ô��ļ��滻:';
$strReset = '����';
$strResourceLimits = '��Դ����';
$strReType = '��������';
$strRevoke = '�ջ�';
$strRevokeAndDelete = '�ջ��û������м���Ȩ�ޣ�Ȼ��ɾ���û���';
$strRevokeAndDeleteDescr = '�û���Ȼӵ�� USAGE Ȩ�ޣ�ֱ������װ��Ȩ�ޡ�';
$strRevokeGrant = '�ջ���ȨȨ��';
$strRevokeGrantMessage = '�����ջ� %s ����ȨȨ��';
$strRevokeMessage = '�����ջ� %s ��Ȩ��';
$strRevokePriv = '�ջ�Ȩ��';
$strRowLength = '�г���';
$strRows = '����';
$strRowsFrom = '�У���ʼ����:';
$strRowSize = ' �д�С ';
$strRowsModeFlippedHorizontal = 'ˮƽ(��ת����)';
$strRowsModeHorizontal = 'ˮƽ';
$strRowsModeOptions = '�� %s ģʽ��ʾ�������� %s ����Ԫ����ظ�����';
$strRowsModeVertical = '��ֱ';
$strRowsStatistic = '��ͳ��';
$strRunning = '������ %s';
$strRunQuery = '�ύ��ѯ';
$strRunSQLQuery = '�����ݿ� %s ���� SQL ��ѯ';

$strSave = '����';
$strSaveOnServer = '�����ڷ������� %s Ŀ¼';
$strScaleFactorSmall = '��������̫С���޷���һҳ����ʾ���';
$strSearch = '����';
$strSearchFormTitle = '�������ݿ�';
$strSearchInTables = '�����±�:';
$strSearchNeedle = '���ҵ����ֻ���ֵ(ͨ���:��%��):';
$strSearchOption1 = '����һ������';
$strSearchOption2 = '���е���';
$strSearchOption3 = '��ȷ����';
$strSearchOption4 = '���������ʽ';
$strSearchResultsFor = '��<i>%s</i>����������� %s:';
$strSearchType = '����:';
$strSelect = 'ѡ��';
$strSelectADb = '��ѡ�����ݿ�';
$strSelectAll = 'ȫѡ';
$strSelectFields = '����ѡ��һ���ֶ�:';
$strSelectNumRows = '��ѯ��';
$strSelectTables = 'ѡ���';
$strSend = '����Ϊ�ļ�';
$strSent = '�ͳ�';
$strServer = '������ %s';
$strServerChoice = 'ѡ�������';
$strServerStatus = '������Ϣ';
$strServerStatusUptime = '�� MySQL �������Ѿ������� %s������ʱ��Ϊ %s��';
$strServerTabProcesslist = '����';
$strServerTabVariables = '����';
$strServerTrafficNotes = '<b>����������</b>: ��Щ����ʾ�˴� MySQL ��������������������������ͳ�ơ�';
$strServerVars = '����������������';
$strServerVersion = '�������汾';
$strSessionValue = '�Ựֵ';
$strSetEnumVal = '���ֶ������ǡ�enum����set������ʹ�����µĸ�ʽ����: \'a\',\'b\',\'c\'...<br />�������Ҫ��ֵ�����뷴б��(��\��)���ߵ�����(��\'��)������ǰ����Ϸ�б��(�� \'\\\\xyz\' �� \'a\\\'b\')��';
$strShow = '��ʾ';
$strShowAll = 'ȫ����ʾ';
$strShowColor = '��ʾ��ɫ';
$strShowCols = '��ʾ��';
$strShowDatadictAs = '�����ֵ��ʽ';
$strShowFullQueries = '��ʾ������ѯ';
$strShowGrid = '��ʾ����';
$strShowingRecords = '��ʾ��';
$strShowPHPInfo = '��ʾ PHP ��Ϣ';
$strShowTableDimension = '��ʾ�����С';
$strShowTables = '��ʾ��';
$strShowThisQuery = ' �ڴ��ٴ���ʾ�˲�ѯ ';
$strSingly = '(��һ)';
$strSize = '��С';
$strSort = '����';
$strSpaceUsage = '��ʹ�ÿռ�';
$strSplitWordsWithSpace = 'ÿ�������Կո� (" ") �ָ���';
$strSQL = 'SQL'; // should express in english
$strSQLOptions = 'SQL ѡ��';
$strSQLParserBugMessage = '�п����������� SQL �������� bug������ϸ������Ĳ�ѯ�����������Ƿ���ȷ���Ƿ�ƥ�䡣�������ܵ�ʧ��ԭ������������ϴ��˳��������ı�������Ķ��������ݡ����������� MySQL �����н�����һ������ ��ѯ��������ܵĻ������»��г� MySQL �������Ĵ������������ܶ������������һ���İ������á��������Ȼ�����⣬���������н���ִ�гɹ����������������뽫���� SQL ��ѯ���������������ĳһ����䣬Ȼ�������������е�����һ���ύһ�� bug ����:';
$strSQLParserUserError = '�������� SQL ��ѯ�д���������ܵĻ������»��г� MySQL �������Ĵ������������ܶ������������һ���İ�������';
$strSQLQuery = 'SQL ��ѯ';
$strSQLResult = 'SQL ��ѯ���';
$strSQPBugInvalidIdentifer = '��Ч�ı�ʶ��';
$strSQPBugUnclosedQuote = '���Ų����';
$strSQPBugUnknownPunctuation = 'δ֪�ı������ַ���';
$strStatCheckTime = '�����ʱ��';
$strStatCreateTime = '����ʱ��';
$strStatement = '���';
$strStatUpdateTime = '������ʱ��';
$strStatus = '״̬';
$strStrucCSV = 'CSV ����';
$strStrucData = '�ṹ������';
$strStrucDrop = '���ӡ�drop talbe��';
$strStrucExcelCSV = 'MS Excel �� CSV ��ʽ';
$strStrucOnly = 'ֻ�ṹ';
$strStructPropose = '�滮���ṹ';
$strStructure = '�ṹ';
$strSubmit = '�ύ';
$strSuccess = '�����е� SQL ����Ѿ��ɹ������ˡ�';
$strSum = '�ܼ�';
$strSwitchToTable = '�л������Ƶı�';

$strTable = '�� ';
$strTableComments = '��ע��';
$strTableEmpty = '�������ǿյ�!';
$strTableHasBeenDropped = '�� %s �ѱ�ɾ��';
$strTableHasBeenEmptied = '�� %s �ѱ����';
$strTableHasBeenFlushed = '�� %s �ѱ�ǿ�ȸ���';
$strTableMaintenance = '��ά��';
$strTableOfContents = 'Ŀ¼';
$strTables = '%s ����';
$strTableStructure = '���Ľṹ';
$strTableType = '������';
$strTblPrivileges = '����ָ��Ȩ��';
$strTextAreaLength = ' ���ڳ�������<br />���ֶο����޷��༭ ';
$strTheContent = '�ļ��е������Ѿ����뵽���С�';
$strTheContents = '�ļ��е����ݽ���ȡ����ѡ�����о�����ͬ������Ψһ���ļ�¼��';
$strTheTerminator = '�ֶεĽ�������';
$strThisHost = '������';
$strThisNotDirectory = '�Ⲣ����һ��Ŀ¼';
$strThreadSuccessfullyKilled = '�߳� %s �ѳɹ�ɱ����';
$strTime = 'ʱ��'; 
$strTotal = '�ܼ�';
$strTotalUC = 'ͳ��'; 
$strTraffic = '����';
$strTransformation_image_jpeg__inline = '��ʾ�ɵ��������ͼ; ѡ��: ������ָ���Ŀ��ȡ��߶�(����ԭ�б���)';
$strTransformation_image_jpeg__link = '��ʾ����ͼ�������(��ֱ�Ӷ���������)��';
$strTransformation_image_png__inline = '�鿴 image/jpeg: Ƕ��';
$strTransformation_text_plain__dateformat = 'ѡ�� TIME, TIMESTAMP �� DATETIME �ֶβ����������ı������ڸ�ʽ���и�ʽ������һ��ѡ���ǽ�����뵽ʱ����е�ƫ����(��СʱΪ��λ��Ĭ��Ϊ 0)���ڶ���ѡ���Ǹ��� PHP �� strftime() ���������ĸ�ʽ��д�Ĳ�ͬ���ڸ�ʽ��';
$strTransformation_text_plain__external = 'ֻ�� LINUX: �����ⲿ����ͨ����׼��������ֶ����ݡ����ش�Ӧ�ó���ı�׼�����Ĭ��Ϊ Tidy�����ԺܺõĴ�ӡ HTML ���롣Ϊ�˰�ȫ���������Ҫ�ֶ��༭�ļ� libraries/transformations/text_plain__external.inc.php Ȼ��������������еĹ��ߡ���һ��ѡ��������Ҫʹ�õĳ����ţ����ڶ���ѡ���ǳ���Ĳ��������ڵ����������������Ϊ 1 �Ļ������� htmlspecialchars() ת�������(Ĭ��Ϊ 1)�����ĸ����������Ϊ 1 �Ļ������������ݵ�Ԫ������� NOWRAP������ȫ������ͻ᲻�����¸�ʽ��ֱ�������(Ĭ��Ϊ 1)';
$strTransformation_text_plain__formatted = '�����ֶε�ԭʼ��ʽ��������ת�롣';
$strTransformation_text_plain__imagelink = '��ʾͼ������ӣ��ֶ��ڰ����ļ�������һ��ѡ�������ơ�http://domain.com/��������ǰ׺���ڶ���ѡ����������Ϊ��λ�Ŀ��ȣ������������Ǹ߶ȡ�';
$strTransformation_text_plain__link = '��ʾ���ӣ��ֶ��ڰ����ļ�������һ��ѡ�������ơ�http://domain.com/��������ǰ׺���ڶ���ѡ�������ӵı���(������ʾ)��';
$strTransformation_text_plain__substr = 'ֻ��ʾ�ַ�����һ���֡���һ��ѡ������ı���ʼ�����ƫ����(Ĭ��Ϊ 0)���ڶ���ѡ��������������������ƫ���������Ϊ�յĻ���������ʣ�µ������ı���������ѡ���ǽ���׷�ӵ����ַ���֮������(Ĭ��Ϊ: ...) .';
$strTransformation_text_plain__unformatted = '�� HTML ������ʾΪ HTML ʵ�塣����ʾ HTML ��ʽ����';
$strTruncateQueries = '�ض���ʾ�Ĳ�ѯ';
$strType = '����';

$strUncheckAll = 'ȫ����ѡ';
$strUnique = 'Ψһ';
$strUnselectAll = 'ȫ����ѡ';
$strUpdatePrivMessage = '���Ѿ������� %s ��Ȩ�ޡ�';
$strUpdateProfile = '��������:';
$strUpdateProfileMessage = '�����ļ������¡�';
$strUpdateQuery = '���²�ѯ';
$strUpdComTab = '��ο��ĵ��й�����θ������� Column_comments ���Ĳ���';
$strUsage = '�÷�';
$strUseBackquotes = '���ڱ������ֶ���ʹ������';
$strUseHostTable = 'ʹ��������';
$strUser = '�û�';
$strUserAlreadyExists = '�û� %s ������!';
$strUserEmpty = '�û������ǿյ�!';
$strUserName = '�û���';
$strUserNotFound = 'ѡ�е��û���Ȩ�ޱ����Ҳ�����';
$strUserOverview = '�û�һ��';
$strUsers = '�û�';
$strUsersDeleted = 'ѡ�е��û��ѳɹ�ɾ����';
$strUsersHavingAccessToDb = '�û��ɷ��ʡ�%s��';
$strUseTables = 'ʹ�ñ�';
$strUseTextField = 'ʹ���ı���'; 

$strValidateSQL = 'У�� SQL';
$strValidatorError = 'SQL У������޷���ʼ���������Ƿ��Ѿ���װ��%s�ĵ�%s�������ı��� PHP ��չ��';
$strValue = 'ֵ';
$strVar = '����';
$strViewDump = '�鿴����ת��(���)��';
$strViewDumpDB = '�鿴���ݿ��ת��(���)��';

$strWebServerUploadDirectory = 'Web ����������Ŀ¼';
$strWebServerUploadDirectoryError = '�趨������Ŀ¼����δ��ʹ��';
$strWelcome = '��ӭʹ�� %s';
$strWildcard = 'ͨ���';
$strWithChecked = 'ѡ����:';
$strWritingCommentNotPossible = '����дע��';
$strWritingRelationNotPossible = '����д��ϵ';
$strWrongUser = '�û���/������󣬷��ʱ��ܾ���';

$strXML = 'XML'; //USE ENG

$strYes = '��';

$strZeroRemovesTheLimit = 'ע�⣺����Щѡ����Ϊ 0 (��)��ɾ�����ơ�';
$strZip = '"zipped"';
?>