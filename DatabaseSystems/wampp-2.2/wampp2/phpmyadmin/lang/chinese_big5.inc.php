<?php
/* $Id: chinese_big5.inc.php,v 1.247 2003/05/29 16:43:58 lem9 Exp $ */

/**
 * Last translation by: Siu Sun <siusun@best-view.net>
 * Follow by the original translation of Taiyen Hung �x����<yen789@pchome.com.tw>
 */

$charset = 'big5';
$text_dir = 'ltr';
$left_font_family = 'verdana, arial, helvetica, geneva, sans-serif';
$right_font_family = 'helvetica, sans-serif';
$number_thousands_separator = ',';
$number_decimal_separator = '.';
// shortcuts for Byte, Kilo, Mega, Giga, Tera, Peta, Exa
$byteUnits = array('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB');

$day_of_week = array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
$month = array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
// See http://www.php.net/manual/en/function.strftime.php to define the
// variable below
$datefmt = '%B %d, %Y, %I:%M %p';

$timespanfmt = '%s ��, %s �p��, %s ���� %s ��';

	

$strAPrimaryKey = '�D��w�g�s�W�� %s';
$strAbortedClients = '����';
$strAccessDenied = '�ڵ��s��';
$strAction = '����';
$strAddDeleteColumn = '�s�W/��� �����';
$strAddDeleteRow = '�s�W/��� �z��C';
$strAddNewField = '�W�[�s���';
$strAddPriv = '�W�[�s�v��';
$strAddPrivMessage = '�z�w�g���U���o��ϥΪ̼W�[�F�s�v��.';
$strAddSearchConditions = '�W�[�˯����� ("where" �l�y���D��)';
$strAddToIndex = '�s�W &nbsp;%s&nbsp; �կ�����';
$strAddUser = '�s�W�ϥΪ�';
$strAddUserMessage = '�z�w�s�W�F�@�ӷs�ϥΪ�.';
$strAdministration = '�t�κ޲z';
$strAffectedRows = '�v�T�C��: ';
$strAfter = '�b %s ����';
$strAfterInsertBack = '��^';
$strAfterInsertNewInsert = '�s�W�@���O��';
$strAll = '����';
$strAllTableSameWidth = '�H�ۦP�e����ܩҦ���ƪ�?';
$strAlterOrderBy = '�ھ���줺�e�ƧǰO��';
$strAnIndex = '���ޤw�g�s�W�� %s';
$strAnalyzeTable = '���R��ƪ�';
$strAnd = '�P';
$strAny = '����';
$strAnyColumn = '�������';
$strAnyDatabase = '�����Ʈw';
$strAnyHost = '����D��';
$strAnyTable = '�����ƪ�';
$strAnyUser = '����ϥΪ�';
$strAscending = '���W';
$strAtBeginningOfTable = '���ƪ��}�Y';
$strAtEndOfTable = '���ƪ�����';
$strAttr = '�ݩ�';
$strAutomaticLayout = '�۰ʮ榡'; 

$strBack = '�^�W�@��';
$strBeginCut = '�}�l �Ũ�';
$strBeginRaw = '�}�l ��l���';
$strBinary = '�G�i��X';
$strBinaryDoNotEdit = '�G�i��X - ����s��';
$strBookmarkDeleted = '���Ҥw�g�R��.';
$strBookmarkLabel = '���ҦW��';
$strBookmarkQuery = 'SQL �y�k����';
$strBookmarkThis = '�N�� SQL �y�k�[�J����';
$strBookmarkView = '�d��';
$strBrowse = '�s��';
$strBzError = 'phpMyAdmin �L�k���Y�]��o�� php ������ Bz2 �Ҳտ��~. �j�C�n�D�� phpMyAdmin �]�w�ɳ]�w <code>$cfg[\'BZipDump\']</code> ��<code>FALSE</code>. �p�G�Q�ϥ� Bz2 ���Y�\��,�Ч�s php ��̷s����. �Ա��аѬ� php ���~���� %s .';
$strBzip = '"bzipped"';

$strCSVOptions = 'CSV �ﶵ';
$strCannotLogin = '�L�k�n�J MySQL ���A��';
$strCantLoadMySQL = '������J MySQL �Ҳ�,<br />���ˬd PHP ���պA�]�w';
$strCantLoadRecodeIconv = '����Ū�� iconv �έ��s�s�X�{���ӧ@��r�s�X�ഫ, �г]�w php �ӱҰʳo�ǼҲթΨ��� phpMyAdmin �ϥΤ�r�s�X�ഫ�\��.';
$strCantRenameIdxToPrimary = '�L�k�N���ާ�W�� PRIMARY!';
$strCantUseRecodeIconv = '����s�X�Ҳ�Ū����,����ϥ� iconv �B libiconv �� recode_string �\��. ���ˬd�z�� php �]�w.';
$strCardinality = '�էO';
$strCarriage = '�k��: \\r';
$strChange = '�ק�';
$strChangeDisplay = '�����ܤ����';
$strChangePassword = '���K�X';
$strCharsetOfFile = '�r�����ɮ�:';
$strCheckAll = '����';
$strCheckDbPriv = '�ˬd��Ʈw�v��';
$strCheckTable = '�ˬd��ƪ�';
$strChoosePage = '�п�ܻݭn�s�誺���X';
$strColComFeat = '���������';
$strColumn = '���';
$strColumnNames = '���W��';
$strCommand = '���O';
$strComments = '����';
$strCompleteInserts = '�ϥΧ���s�W���O';
$strCompression = '���Y';
$strConfigFileError = 'phpMyAdmin ����Ū���z���]�w��! �o�i��O�]�� php ���y�k�W�����~�� php �������ɮצӦ�.<br />�й��ժ������U�U�誺�s���}�Ҩìd�� php �����~�H��. �q�`�����~���Ӧ۬Y�B�|�F�޸��Τ��O.<br />�p�G���U�s����X�{�ťխ�, �Y�N���S��������D.';
$strConfigureTableCoord = '�г]�w���� %s ��������';
$strConfirm = '�z�T�w�n�o�˰��H';
$strConnections = '�s�u';
$strCookiesRequired = 'Cookies �����Ұʤ~��n�J.';
$strCopyTable = '�ƻs��ƪ���G (�榡�� ��Ʈw�W��<b>.</b>��ƪ��W��):';
$strCopyTableOK = '�w�g�N��ƪ� %s �ƻs�� %s.';
$strCouldNotKill = 'phpMyAdmin �L�k���_���O %s. �i��o���O�w�g����.';
$strCreate = '�إ�';
$strCreateIndex = '�s�W &nbsp;%s&nbsp; �կ�����';
$strCreateIndexTopic = '�s�W�@�կ���';
$strCreateNewDatabase = '�إ߷s��Ʈw';
$strCreateNewTable = '�إ߷s��ƪ����Ʈw %s';
$strCreatePage = '�إ߷s�@��';
$strCreatePdfFeat = '�إ� PDF';
$strCriteria = '�z��';

$strDBGHits = '����'; 
$strDBGLine = '��'; 
$strDBGModule = '�Ҳ�';
$strData = '���';
$strDataDict = '�ƾڦr��';
$strDataOnly = '�u�����';
$strDatabase = '��Ʈw';
$strDatabaseHasBeenDropped = '��Ʈw %s �w�Q�R��';
$strDatabaseWildcard = '��Ʈw (���\�ϥθU�Φr��):';
$strDatabases = '��Ʈw';
$strDatabasesStats = '��Ʈw�έp';
$strDefault = '�w�]��';
$strDelete = '�R��';
$strDeleteAndFlush = '�R���ϥΪ̤έ��sŪ���v��.'; 
$strDeleteAndFlushDescr = '�o�O�@�ӳ̲M�䪺���k,�����sŪ���v���ݤ@�q�ɶ�.';
$strDeleteFailed = '�R������!';
$strDeleteUserMessage = '�z�w�g�N�ϥΪ� %s �R��.';
$strDeleted = '�O���w�Q�R��';
$strDeletedRows = '�w�R�����:';
$strDeleting = '�R�� %s';
$strDescending = '����';
$strDisabled = '���Ұ�';
$strDisplay = '���';
$strDisplayFeat = '�\�����';
$strDisplayOrder = '��ܦ���';
$strDisplayPDF = '��� PDF ���n';
$strDoAQuery = '�H�d�Ҭd�� (�U�Φr�� : "%")';
$strDoYouReally = '�z�T�w�n ';
$strDocu = '�������';
$strDrop = '�R��';
$strDropDB = '�R����Ʈw %s';
$strDropTable = '�R����ƪ�';
$strDumpXRows = '�ƥ� %s ��, �� %s ��}�l.';
$strDumpingData = '�C�X�H�U��Ʈw���ƾڡG';
$strDynamic = '�ʺA';

$strEdit = '�s��';
$strEditPDFPages = '�s�� PDF ���X';
$strEditPrivileges = '�s���v��';
$strEffective = '���';
$strEmpty = '�M��';
$strEmptyResultSet = 'MySQL �Ǧ^���d�ߵ��G���� (��]�i�ର�G�S�����ŦX���󪺰O��)';
$strEnabled = '�Ұ�';
$strEnd = '�̫�@��';
$strEndCut = '���� �Ũ�';
$strEndRaw = '���� ��l���';
$strEnglishPrivileges = '�`�N: MySQL �v���W�ٷ|�H�^�y���';
$strError = '���~';
$strExplain = '���� SQL';
$strExport = '��X';
$strExportToXML = '��X�� XML �榡';
$strExtendedInserts = '�����s�W�Ҧ�';
$strExtra = '���[';

$strFailedAttempts = '���ե���';
$strField = '���';
$strFieldHasBeenDropped = '��ƪ� %s �w�Q�R��';
$strFields = '���';
$strFieldsEmpty = ' ����`�ƬO�Ū�! ';
$strFieldsEnclosedBy = '�u���v�ϥΦr���G';
$strFieldsEscapedBy = '�uESCAPE�v�ϥΦr���G';
$strFieldsTerminatedBy = '�u�����j�v�ϥΦr���G';
$strFileCouldNotBeRead = 'Ū�׵L�kŪ��';
$strFixed = '�T�w';
$strFlushPrivilegesNote = '��: phpMyAdmin ������ MySQL �v����ƪ����o�ϥΪ��v��. �p�G�ϥΪ̦ۦ����ƪ�, ��ƪ����e�N�i��P��ڨϥΪ̱��p����. �b�o���p�U, �z���b�~��e %s���s���J%s �v����ƪ�.';
$strFlushTable = '�j����s��ƪ� ("FLUSH")';
$strFormEmpty = '���椺�|��@�Ǹ��!';
$strFormat = '�榡';
$strFullText = '��ܧ����r';
$strFunction = '���';

$strGenBy = '�إ�';
$strGenTime = '�إߤ��';
$strGeneralRelationFeat = '�@�����p�\��';
$strGlobalPrivileges = '�����v��';
$strGlobalValue = '�����';
$strGo = '����';
$strGrantOption = '���v';
$strGrants = 'Grants'; //should expressed in English
$strGzip = '"gzipped"';

$strHasBeenAltered = '�w�g�ק�';
$strHasBeenCreated = '�w�g�إ�';
$strHaveToShow = '�z�ݭn��̤ܳ���ܤ@�����';
$strHome = '�D�ؿ�';
$strHomepageOfficial = 'phpMyAdmin �x�����';
$strHomepageSourceforge = 'phpMyAdmin �U������';
$strHost = '�D��';
$strHostEmpty = '�п�J�D���W��!';

$strId = 'ID'; // use eng
$strIdxFulltext = '�����˯�';
$strIfYouWish = '�p�G�z�n���w��ƶפJ�����A�п�J�γr���j�}�����W��';
$strIgnore = '����';
$strImportDocSQL = 'Ū�� docSQL �ɮ�'; 
$strImportFiles = '��J�ɮ�'; 
$strImportFinished = '��J����'; 
$strInUse = '�ϥΤ�';
$strIndex = '����';
$strIndexHasBeenDropped = '���� %s �w�Q�R��';
$strIndexName = '���ަW��&nbsp;:';
$strIndexType = '��������&nbsp;:';
$strIndexes = '����';
$strInsecureMySQL = '�]�w�ɤ������]�w (root�n�J�ΨS���K�X) �P�w�]�� MySQL �v����f�ۦP�C MySQL ���A���b�o�w�]���]�w�B�檺�ܷ|�ܮe���Q�J�I�A�z����靈���]�w�h����w���|�}�C';
$strInsert = '�s�W';
$strInsertAsNewRow = '�x�s���s�O��';
$strInsertNewRow = '�s�W�@���O��';
$strInsertTextfiles = '�N��r�ɸ�ƶפJ��ƪ�';
$strInsertedRows = '�s�W�C��:';
$strInstructions = '���O';
$strInvalidName = '"%s" �O�@�ӫO�d�r,�z����N�O�d�r�ϥά� ��Ʈw/��ƪ�/��� �W��.';

$strJustDelete = '�u�q�v����Ʈw�R���ϥΪ�.';
$strJustDeleteDescr = ' &quot;�R��&quot; ���ϥΪ̤��M����n�J��Ʈw���ܭ��s���J��Ʈw����.';

$strKeepPass = '�Ф��n���K�X';
$strKeyname = '��W';
$strKill = 'Kill'; //should expressed in English

$strLaTeX = 'LaTeX';  // use eng
$strLandscape = '��V';
$strLength = '����';
$strLengthSet = '����/���X*';
$strLimitNumRows = '���O��/�C��';
$strLineFeed = '����: \\n';
$strLines = '���';
$strLinesTerminatedBy = '�u�U�@��v�ϥΦr���G';
$strLinkNotFound = '�䤣��s��';
$strLinksTo = '�s����';
$strLocalhost = '���a';
$strLocationTextfile = '��r�ɮת���m';
$strLogPassword = '�K�X:';
$strLogUsername = '�n�J�W��:';
$strLogin = '�n�J';
$strLoginInformation = '�n�J��T'; 
$strLogout = '�n�X�t��';

$strMissingBracket = '�䤣��A��';
$strModifications = '�ק�w�x�s';
$strModify = '�ק�';
$strModifyIndexTopic = '�ק����';
$strMoreStatusVars = '��h���p��T';
$strMoveTable = '���ʸ�ƪ���G(�榡�� ��Ʈw�W��<b>.</b>��ƪ��W��)';
$strMoveTableOK = '��ƪ� %s �w�g���ʨ� %s.';
$strMySQLCharset = 'MySQL ��r�s�X';
$strMySQLReloaded = 'MySQL ���s���J����';
$strMySQLSaid = 'MySQL �Ǧ^�G ';
$strMySQLServerProcess = 'MySQL ���� %pma_s1% �b %pma_s2% ����A�n�J�̬� %pma_s3%';
$strMySQLShowProcess = '��ܵ{�� (Process)';
$strMySQLShowStatus = '��� MySQL ���檬�A';
$strMySQLShowVars = '��� MySQL �t���ܼ�';

$strName = '�W��';
$strNext = '�U�@��';
$strNo = ' �_ ';
$strNoDatabases = '�S����Ʈw';
$strNoDescription = '�S������';
$strNoDropDatabases = '"DROP DATABASE" ���O�w�g����.';
$strNoExplain = '���L���� SQL';
$strNoFrames = 'phpMyAdmin �����A�X�ϥΦb�䴩<b>����</b>���s����.';
$strNoIndex = '�S���w�w�q������!';
$strNoIndexPartsDefined = '�������޸���٥��w�q!';
$strNoModification = '�S���ܧ�';
$strNoOptions = '�o�خ榡�õL�ﶵ';
$strNoPassword = '���αK�X';
$strNoPhp = '���� PHP �{���X';
$strNoPrivileges = '�S���v��';
$strNoQuery = '�S�� SQL �y�k!';
$strNoRights = '�z�{�b�S���������v��!';
$strNoTablesFound = '��Ʈw���S����ƪ�';
$strNoUsersFound = '�䤣��ϥΪ�';
$strNoUsersSelected = '�S����ܨϥΪ�.';
$strNoValidateSQL = '���L�ˬd SQL';
$strNone = '���A��';
$strNotNumber = '�o���O�@�ӼƦr!';
$strNotOK = '����T�w';
$strNotSet = '<b>%s</b> ��ƪ��䤣����٥��b %s �]�w';
$strNotValidNumber = '���O���Ī��C��!';
$strNull = 'Null'; //should expressed in English
$strNumSearchResultsInTable = '%s ����ƲŦX - ���ƪ� <i>%s</i>';
$strNumSearchResultsTotal = '<b>�`�p:</b> <i>%s</i> ����ƲŦX';
$strNumTables = '�Ӹ�ƪ�';

$strOK = '�T�w';
$strOftenQuotation = '�̱`�Ϊ��O�޸��A�u�D�����v���ܥu�� char �M varchar ���|�Q�]�A�_��';
$strOperations = '�޲z';
$strOptimizeTable = '�̨ΤƸ�ƪ�';
$strOptionalControls = '�D���n�ﶵ�A�Ψ�Ū�g�S���r��';
$strOptionally = '�D����';
$strOptions = '�ﶵ';
$strOr = '��';
$strOverhead = '�h�l';

$strPHP40203 = '�z���ϥ� PHP ���� 4.2.3, �o�������@�����r�`�r�����Y�����~(mbstring). �аѾ\ PHP ���γ��i�s�� 19404. phpMyAdmin �ä���ĳ�ϥγo�Ӫ����� PHP .';
$strPHPVersion = 'PHP ����';
$strPageNumber = '���X:';
$strPartialText = '��ܳ�����r';
$strPassword = '�K�X';
$strPasswordChanged = '%s ���K�X�w���\���.';
$strPasswordEmpty = '�п�J�K�X!';
$strPasswordNotSame = '�ĤG����J���K�X���P!';
$strPdfDbSchema = '"%s" ��Ʈw���n - �� %s ��';
$strPdfInvalidPageNum = 'PDF ���X�S���]�w!';
$strPdfInvalidTblName = '��ƪ� "%s" ���s�b!';
$strPdfNoTables = '�S����ƪ�';
$strPerHour = '�C�p��'; 
$strPerMinute = '�C����';
$strPerSecond = '�C��';
$strPhp = '�إ� PHP �{���X';
$strPmaDocumentation = 'phpMyAdmin �������';
$strPmaUriError = ' �����]�w <tt>$cfg[\'PmaAbsoluteUri\']</tt> �b�]�w�ɤ�!';
$strPortrait = '���V';
$strPos1 = '�Ĥ@��';
$strPrevious = '�e�@��';
$strPrimary = '�D��';
$strPrimaryKey = '�D��';
$strPrimaryKeyHasBeenDropped = '�D��w�Q�R��';
$strPrimaryKeyName = '�D�䪺�W�٥����٬� PRIMARY!';
$strPrimaryKeyWarning = '("PRIMARY" <b>����</b>�O�D�䪺�W�٥H�άO<b>�ߤ@</b>�@�եD��!)';
$strPrint = '�C�L';
$strPrintView = '�C�L�˵�';
$strPrivDescAllPrivileges = '�]�A�Ҧ��v�����F���v (GRNANT).';
$strPrivDescAlter = '�e�\�ק�{����ƪ������c.';
$strPrivDescCreateDb = '�e�\�إ߷s��Ʈw�θ�ƪ�.'; 
$strPrivDescCreateTbl = '�e�\�إ߷s��ƪ�.';
$strPrivDescCreateTmpTable = '�e�\�إ߼Ȯɩʸ�ƪ�.'; 
$strPrivDescDelete = '�e�\�R���O��.';
$strPrivDescDropDb = '�e�\�R����Ʈw�θ�ƪ�.'; 
$strPrivDescDropTbl = '�e�\�R����ƪ�.'; 
$strPrivDescMaxConnections = '����C�p�ɨϥΪ̶}�ҷs�s�u���ƥ�.';
$strPrivDescMaxQuestions = '����C�p�ɨϥΪ̬d�ߪ��ƥ�.';
$strPrivDescMaxUpdates = '����C�p�ɨϥΪ̧���ƪ��μƾڪ������O���ƥ�.';
$strPrivileges = '�v��';
$strProcesslist = '�t�ΰ���M��';
$strProperties = '�ݩ�';
$strPutColNames = '�N���W�٩�b����';

$strQBE = '�̽d�Ҭd�� (QBE)';
$strQBEDel = '����';
$strQBEIns = '�s�W';
$strQueryOnDb = '�b��Ʈw <b>%s</b> ���� SQL �y�k:';
$strQueryStatistics = '<b>�d�ڲέp</b>: ���έp�Ұʫ�, �@�� %s �Ӭd�߶ǰe�즹���A��.';
$strQueryType = '�d�ߤ覡';

$strReType = '�T�{�K�X';
$strReceived = '����';
$strRecords = '�O��';
$strReferentialIntegrity = '�ˬd���ܧ����:';
$strRelationNotWorking = '���p��ƪ������[�\�ॼ��Ұ�, %s�Ы���%s �d�X���D��].';
$strRelationView = '���p�˵�';
$strReloadFailed = '���s���JMySQL����';
$strReloadMySQL = '���s���J MySQL';
$strRememberReload = '�аO�ۭ��s�Ұʦ��A��.';
$strRenameTable = '�N��ƪ���W��';
$strRenameTableOK = '�w�g�N��ƪ� %s ��W�� %s';
$strRepairTable = '�״_��ƪ�';
$strReplace = '���N';
$strReplaceTable = '�H�ɮר��N��ƪ����';
$strReset = '���m';
$strRevoke = '����';
$strRevokeGrant = '���� Grant �v��';
$strRevokeGrantMessage = '�z�w�����o��ϥΪ̪� Grant �v��: %s';
$strRevokeMessage = '�z�w�����o��ϥΪ̪��v��: %s';
$strRevokePriv = '�����v��';
$strRowLength = '��ƦC����';
$strRowSize = '��ƦC�j�p';
$strRows = '��ƦC�C��';
$strRowsFrom = '���O���A�}�l�C��:';
$strRowsModeHorizontal = '����';
$strRowsModeOptions = '��ܬ� %s �覡 �� �C�j %s �������W';
$strRowsModeVertical = '����';
$strRowsStatistic = '��ƦC�έp�ƭ�';
$strRunQuery = '����y�k';
$strRunSQLQuery = '�b��Ʈw %s ����H�U���O';
$strRunning = '�b %s ����';

$strSQL = 'SQL'; // should express in english
$strSQLOptions = 'SQL �ﶵ';
$strSQLParserBugMessage = '�o�i��O�z���F SQL ���R�{�����@�ǵ{�����~�A�вӤ߬d�ݱz���y�k�A�ˬd�@�U�޸��O���T�ΨS����|�A��L�i��X������]�i��Ӧ۱z�W���ɮ׮ɦb�޸��~���a��ϥΤF�G�i��X�C�z�i�H���զb MySQL �R�O�C��������ӻy�k�C�p MySQL ���A���o�X���~�H���A�o�i�����U�z�h��X���D�Ҧb�C�p�z���M����ѨM���D�A�Φb���R�{���X�{���~�A���b�R�O�C�Ҧ��ॿ�`����A�бN�ӥy�X�{���~�� SQL �y�k��X�A�ñN�H�U��"�Ũ�"�����@�P��������:';
$strSQLParserUserError = '�i��O�z�� SQL �y�k�X�{���~�A�p MySQL ���A���o�X���~�H���A�o�i�����U�z�h��X���D�Ҧb�C';
$strSQLQuery = 'SQL �y�k';
$strSQLResult = 'SQL �d�ߵ��G';
$strSQPBugInvalidIdentifer = '�L�Ī��ѧO�X (Invalid Identifer)';
$strSQPBugUnclosedQuote = '���������޸� (Unclosed quote)';
$strSQPBugUnknownPunctuation = '�����������I�Ÿ� (Unknown Punctuation String)';
$strSave = '�x�s';
$strScaleFactorSmall = '��ҭ��ƤӲ�, �L�k�N�Ϫ���b�@����';
$strSearch = '�j��';
$strSearchFormTitle = '�j����Ʈw';
$strSearchInTables = '��H�U��ƪ�:';
$strSearchNeedle = '�M�䤧��r�μƭ� (�U�Φr��: "%"):';
$strSearchOption1 = '����@�դ�r';
$strSearchOption2 = '�Ҧ���r';
$strSearchOption3 = '������y';
$strSearchOption4 = '�H�W�h���ܪk (regular expression) �j��';
$strSearchResultsFor = '�j�� "<i>%s</i>" �����G %s:';
$strSearchType = '�M��:';
$strSelect = '���';
$strSelectADb = '�п�ܸ�Ʈw';
$strSelectAll = '����';
$strSelectFields = '������ (�ܤ֤@��)';
$strSelectNumRows = '�d�ߤ�';
$strSelectTables = '��ܸ�ƪ�';
$strSend = '�U���x�s';
$strSent = '�e�X';
$strServer = '���A�� %s';
$strServerChoice = '��ܦ��A��';
$strServerStatus = '�B���T';
$strServerTabProcesslist = '�B�z';
$strServerTabVariables = '��T';
$strServerTrafficNotes = '<b>���A���y�q</b>: �o�Ǫ���ܤF�� MySQL ���A���۱ҰʥH�Ӫ������y�q�έp�C';
$strServerVars = '���A����T�γ]�w';
$strServerVersion = '���A������';
$strSessionValue = '�{�Ǽƭ�';
$strSetEnumVal = '�p���榡�O "enum" �� "set", �ШϥΥH�U���榡��J: \'a\',\'b\',\'c\'...<br />�p�b�ƭȤW�ݭn��J�ϱ׽u (\) �γ�޸� (\') , �ЦA�[�W�ϱ׽u (�Ҧp \'\\\\xyz\' or \'a\\\'b\').';
$strShow = '���';
$strShowAll = '��ܥ���';
$strShowColor = '����C��';
$strShowCols = '�����';
$strShowDatadictAs = '�ƾڦr��榡';
$strShowGrid = '��ܮخ�';
$strShowPHPInfo = '��� PHP ��T';
$strShowTableDimension = '��ܪ���j�p';
$strShowTables = '��ܸ�ƪ�';
$strShowThisQuery = '���s��� SQL �y�k ';
$strShowingRecords = '��ܰO��';
$strSingly = '(�u�|�Ƨǲ{�ɪ��O��)';
$strSize = '�j�p';
$strSort = '�Ƨ�';
$strSpaceUsage = '�w�ϥΪŶ�';
$strSplitWordsWithSpace = '�C�դ�r�H�Ů� (" ") ���j.';
$strStatCheckTime = '�̫��ˬd';
$strStatCreateTime = '�إ�';
$strStatUpdateTime = '�̫��s';
$strStatement = '�ԭz';
$strStatus = '���A';
$strStrucCSV = 'CSV ���';
$strStrucData = '���c�P���';
$strStrucDrop = '�W�[ \'�R����ƪ�\' �y�k';
$strStrucExcelCSV = 'Ms Excel �� CSV �榡';
$strStrucOnly = '�u�����c';
$strStructPropose = '���R��ƪ����c';
$strStructure = '���c';
$strSubmit = '�e�X';
$strSuccess = '�z��SQL�y�k�w���Q����';
$strSum = '�`�p';

$strTable = '��ƪ�';
$strTableComments = '��ƪ����Ѥ�r';
$strTableEmpty = '�п�J��ƪ��W��!';
$strTableHasBeenDropped = '��ƪ� %s �w�Q�R��';
$strTableHasBeenEmptied = '��ƪ� %s �w�Q�M��';
$strTableHasBeenFlushed = '��ƪ� %s �w�Q�j����s';
$strTableMaintenance = '��ƪ����@';
$strTableOfContents = '�ؿ�';
$strTableStructure = '��ƪ��榡�G';
$strTableType = '��ƪ�����';
$strTables = '%s ��ƪ�';
$strTextAreaLength = ' �ѩ���׭���<br /> ����줣��s�� ';
$strTheContent = '�ɮפ��e�w�g�פJ��ƪ�';
$strTheContents = '�ɮפ��e�N�|���N��w����ƪ����㦳�ۦP�D��ΰߤ@�䪺�O��';
$strTheTerminator = '���j��쪺�r��';
$strThisHost = '���w�D��';
$strThisNotDirectory = '�o�ä��O�@�ӥؿ�';
$strThreadSuccessfullyKilled = '���O %s �w���\����.';
$strTime = '�ɶ�'; 
$strTotal = '�`�p';
$strTotalUC = '�`�@'; 
$strTraffic = '�y�q';
$strType = '���A';

$strUncheckAll = '��������';
$strUnique = '�ߤ@';
$strUnselectAll = '��������';
$strUpdatePrivMessage = '�z�w�g��s�F %s ���v��.';
$strUpdateProfile = '��s���:';
$strUpdateProfileMessage = '��Ƥv�g��s.';
$strUpdateQuery = '��s�y�k';
$strUsage = '�ϥ�';
$strUseBackquotes = '�Цb��ƪ������ϥΤ޸�';
$strUseTables = '�ϥθ�ƪ�';
$strUseTextField = '��r��J'; 
$strUser = '�ϥΪ�';
$strUserEmpty = '�п�J�ϥΪ̦W��!';
$strUserName = '�ϥΪ̦W��';
$strUserNotFound = '��ܪ��ϥΪ̦b�v����ƪ����䤣��.';
$strUserOverview = '�ϥΪ̤@��';
$strUsers = '�ϥΪ�';
$strUsersDeleted = '��ܪ��ϥΪ̤w���\�R��.';

$strValidateSQL = '�ˬd SQL';
$strValidatorError = 'SQL ���R�{������ҰʡA���ˬd�O�_�w�N %s���%s ���� PHP �ɮצw�ˡC';
$strValue = '��';
$strVar = '��T';
$strViewDump = '�˵���ƪ����ƥ����n (dump schema)';
$strViewDumpDB = '�˵���Ʈw���ƥ����n (dump schema)';

$strWebServerUploadDirectory = 'Web ���A���W���ؿ�';
$strWebServerUploadDirectoryError = '�]�w���W���ؿ����~�A����ϥ�';
$strWelcome = '�w��ϥ� %s';
$strWithChecked = '��ܪ���ƪ��G';
$strWrongUser = '���~���ϥΪ̦W�٩αK�X�A�ڵ��s��';

$strXML = 'XML'; //USE ENG

$strYes = ' �O ';

$strZip = '"zipped"';
// To translate
$strUpdComTab = '�аѬݻ������d�ߦp���s Column_comments ��ƪ�';

$strAbsolutePathToDocSqlDir = '�п�J docSQL �ؿ���������A����������|';
$strAddPrivilegesOnDb = '��H�U��Ʈw�[�J�v��';
$strAddPrivilegesOnTbl = '��H�U��ƪ��[�J�v��'; 
$strAddedColumnComment = '��H�U���[�J���Ѥ�r';
$strAddedColumnRelation = '��H�U���[�J���p'; 

$strCantLoad = '�L�kŪ�� %s �Ҳ�,<br />���ˬd PHP �]�w';
$strChangeCopyMode = '�إ߷s�ϥΪ̤ΨϥάۦP���v��, �� ...';
$strChangeCopyModeCopy = '... �O�d�¨ϥΪ�.';
$strChangeCopyModeDeleteAndReload = ' ... �R���¨ϥΪ̤έ��sŪ���v����ƪ�.';
$strChangeCopyModeJustDelete = ' ... �R���¨ϥΪ�.';
$strChangeCopyModeRevoke = ' ... �o���Ҧ��¨ϥΪ̦��Ĥ��v���çR��.';
$strChangeCopyUser = '���n�J��T / �ƻs�ϥΪ�';
$strCheckPrivs = '�d���v��';
$strCheckPrivsLong = '�d�߸�Ʈw &quot;%s&quot; ���v��.';
$strColumnPrivileges = '���w����v��';

$strDBComment = '��Ʈw���Ѥ�r: ';
$strDBGContext = '���� (Context)';
$strDBGContextID = '���� (Context) ID';
$strDBGMaxTimeMs = '�̤j�ɶ�, ms';
$strDBGMinTimeMs = '�̤p�ɶ�, ms';
$strDBGTimePerHitMs = '�ɶ�/��, ms';
$strDBGTotalTimeMs = '�`�ɶ�, ms';
$strDatabasesDropped = '%s �Ӹ�Ʈw�w���\�R��.';
$strDatabasesStatsDisable = '����έp�ƾ�';
$strDatabasesStatsEnable = '�Ұʲέp�ƾ�';
$strDatabasesStatsHeavyTraffic = '��: �Ұʸ�Ʈw�έp�ƾڥi��|���ͤj�q�� Web ���A���� MySQL �������y�q.';
$strDbPrivileges = '���w��Ʈw�v��';
$strDbSpecific = '���w��Ʈw';
$strDefaultValueHelp = '�w�]��: �Хu��J�ӹw�]��, �L�ݥ[�W����ϱ׽u�Τ޸�';
$strDelOld = '�������ѦҨ��ƪ��w���s�b. �z�Ʊ�R���o�ǰѦҶ�?';
$strDropSelectedDatabases = '�R���w��ܤ���Ʈw';
$strDropUsersDb = '�R���P�ϥΪ̬ۦP�W�٤���Ʈw.';
$strDumpComments = '�[�J�����ѧ@������ SQL-����';

$strFileNameTemplate = '�ɮצW�ټ˦�';
$strFileNameTemplateHelp = '�ϥ� __DB__ �@����Ʈw�W��, __TABLE__ ����ƪ��W��. %s���� strftime%s ������ɶ��Ϊ��[�ﶵ�|�۰ʥ[�J. ��L��r�N�|�O�d.';
$strFileNameTemplateRemember = '�O�d�˦��W��';

$strGlobal = '����';

$strIgnoringFile = '�����ɮ� %s';
$strInnodbStat = 'InnoDB ���A';

$strJumpToDB = '�����Ʈw &quot;%s&quot;.';

$strMIME_MIMEtype = 'MIME ����';
$strMIME_available_mime = '�i�ϥ� MIME ����';
$strMIME_available_transform = '�i�ϥ��ഫ�覡';
$strMIME_description = '����';
$strMIME_file = '�ɮצW��';
$strMIME_nodescription = '�o���ഫ�覡�S������.<br />�ЦV�@�̬d�� %s �O�ƻ�γ~.';
$strMIME_transformation = '�s�����ഫ�覡';
$strMIME_transformation_note = '�����i�ϥΤ��ഫ�覡�ﶵ�� MINE �����ഫ�ﶵ, �Ьd�� %s�ഫ�覡����%s';
$strMIME_transformation_options = '�ഫ�覡�ﶵ';
$strMIME_transformation_options_note = '�ХΥH�U���榡��J�ഫ�ﶵ��: \'a\',\'b\',\'c\'...<br />�p�z�ݭn��J�ϱ׽u ("\") �γ�޸� ("\'") �ЦA�[�W�ϱ׽u (�Ҧp \'\\\\xyz\' or \'a\\\'b\').';
$strMIME_without = 'MIME �����H������ܬO�S�����j�ഫ�\��';

$strNoDatabasesSelected = '�S����Ʈw���.';

$strPrivDescExecute = '�e�\ ����w���x�s���{��. �� MySQL �����L��.';
$strPrivDescFile = '�e�\��J�ο�X�ƾڨ��ɮ�.';
$strPrivDescGrant = '�e�\�s�W�ϥΪ̤��v���ӵL�ݭ��sŪ���v����ƪ�.';
$strPrivDescIndex = '�e�\�إߤΧR������.';
$strPrivDescInsert = '�e�\�s�W�Ψ��N�ƾ�.';
$strPrivDescLockTables = '�e�\��W�{�ɳs�u����ƪ�.';
$strPrivDescProcess3 = '�e�\�����L�ϥΪ̤��{��.';
$strPrivDescProcess4 = '�e�\�˵��t�ΰ���M�槹�㤧�d��.';
$strPrivDescReferences = '�� MySQL �����L��.';
$strPrivDescReload = '�e�\���sŪ�����A���]�w�αj���s���A���֨��O��.';
$strPrivDescSelect = '�e�\Ū���ƾ�.';
$strPrivDescShowDb = '�iŪ����Ӹ�Ʈw�M��.';
$strPrivDescShutdown = '�e�\������A��.';
$strPrivDescSuper = '�e�\�s�u, �N��W�L�F�̤j�s�u����; �Ω�̰��t�κ޲z�p�]�w�����v���Τ����L�ϥΪ̫��O.';
$strPrivDescUpdate = '�e�\��s�ƾ�.';
$strPrivDescUsage = '�S���v��.'; 
$strPrivilegesReloaded = '�v���w���\���sŪ��.';

$strQueryFrame = '�d�ߵ���';
$strQueryFrameDebug = '������T';
$strQuerySQLHistory = 'SQL ���{';
$strQueryTime = '�d�߻ݮ� %01.4f ��';

$strRelationalSchema = '���p���n';
$strReloadingThePrivileges = '���sŪ���v��'; 
$strRemoveSelectedUsers = '�����w��ܨϥΪ�';
$strResourceLimits = '�귽����';
$strRevokeAndDelete = '�o���ϥΪ̩Ҧ����Ĥ��v���çR��.'; 
$strRevokeAndDeleteDescr = '�ϥΪ̤��M�� USAGE �v�������v����ƪ���sŪ��.';
$strRowsModeFlippedHorizontal = '���� (������D)';

$strServerStatusUptime = '�o MySQL ���A���w�ҰʤF %s. ���A���� %s �Ұ�.';

$strTblPrivileges = '���w��ƪ��v��';
$strTransformation_image_jpeg__inline = '��ܥi�����Ϲ�; �ﶵ; �e��,����[�H���������] (�O�ɭ즳���)';
$strTransformation_image_jpeg__link = '��ܹϹ����s�u (�����U��).';
$strTransformation_image_png__inline = '�Ѭ� image/jpeg: ����';  
$strTransformation_text_plain__dateformat = '�ϥ� TIME, TIMESTAMP �� DATETIME �åH���a�ɰϮɶ����. �Ĥ@�ӿﶵ�O�ץ� (�H�p�ɬ����) �ӽվ���ܤ��ɶ� (�w�]: 0). �ĤG�ӿﶵ�O����榡 [��� PHPs strftime() ���Ѽ�].';

$strUserAlreadyExists = '�ϥΪ� %s �v�s�b!';
$strUsersHavingAccessToDb = '�iŪ�� &quot;%s&quot; ���ϥΪ�';

$strWildcard = '�U�Φr��';
$strWritingCommentNotPossible = '�L�k�x�s���Ѥ�r';
$strWritingRelationNotPossible = '�L�k�x�s���p';

$strZeroRemovesTheLimit = '��: �]�w�o�ǿﶵ�� 0 (�s) �i�Ѱ�����.';
$strAutodetect = '�۰ʰ���';  
$strTransformation_text_plain__imagelink = '��ܹϹ��γs��, �ƾڤ��e�O�ɮצW��; �Ĥ@�ӿﶵ�O���}�e�q (�� "http://domain.com/" ), �ĤG�ӿﶵ�O�e�ת�����,�ĤT�ӿﶵ�O���ת�����.';
$strTransformation_text_plain__link = '��ܳs��, �ƾڤ��e�O�ɮצW��; �Ĥ@�ӿﶵ�O���}�e�q (�� "http://domain.com/" ), �ĤG�ﶵ�O�s�������D.';
$strUseHostTable = '�ϥΥD����ƪ�';
$strShowFullQueries = '��ܧ���d��'; 
$strTruncateQueries = '�R���w��ܬd��';
$strSwitchToTable = '����w�ƻs����ƪ�';
$strCharset = '��r�榡 (Charset)';
$strLaTeXOptions = 'LaTeX �ﶵ';
$strRelations = '���p';
$strMoveTableSameNames = '�L�k���ʨ�ۦP��ƪ�!';
$strCopyTableSameNames = '�L�k�ƻs��ۦP��ƪ�!';
$strMustSelectFile = '�z����ܻݭn�s�W���ɮ�.';
$strSaveOnServer = '�x�s����A���� %s �ؿ�';
$strOverwriteExisting = '�мg�w�s�b�ɮ�';
$strFileAlreadyExists = '�ɮ� %s �w�s�b,�Ч���ɮצW�٩ο�ܡu�мg�v�s�b�ɮסv�ﶵ.';
$strDumpSaved = '�ƥ��w�x���ɮ� %s.';
$strNoPermission = 'Web ���A���S���v���x�s�ɮ� %s.';
$strNoSpace = '�Ŷ������x�s�ɮ� %s.';
$strInsertedRowId = '�s�W��ƦC id:';

$strPrivDescReplClient = 'Gives the right to the user to ask where the slaves / masters are.'; //to translate
$strPrivDescReplSlave = 'Needed for the replication slaves.'; //to translate
$strQueryFrameDebugBox = 'Active variables for the query form:\nDB: %s\nTable: %s\nServer: %s\n\nCurrent variables for the query form:\nDB: %s\nTable: %s\nServer: %s\n\nOpener location: %s\nFrameset location: %s.';//to translate
$strTransformation_text_plain__external = 'LINUX ONLY: Launches an external application and feeds the fielddata via standard input. Returns standard output of the application. Default is Tidy, to pretty print HTML code. For security reasons, you have to manually edit the file libraries/transformations/text_plain__external.inc.php and insert the tools you allow to be run. The first option is then the number of the program you want to use and the second option are the parameters for the program. The third parameter, if set to 1 will convert the output using htmlspecialchars() (Default is 1). A fourth parameter, if set to 1 will put a NOWRAP to the content cell so that the whole output will be shown without reformatting (Default 1)';//to translate
$strTransformation_text_plain__formatted = 'Preserves original formatting of the field. No Escaping is done.';//to translate
$strTransformation_text_plain__substr = 'Only shows part of a string. First option is an offset to define where the output of your text starts (Default 0). Second option is an offset how much text is returned. If empty, returns all the remaining text. The third option defines which chars will be appended to the output when a substring is returned (Default: ...) .';//to translate
$strTransformation_text_plain__unformatted = 'Displays HTML code as HTML entities. No HTML formatting is shown.';//to translate

$strLoadMethod = 'LOAD method';  //to translate
$strLoadExplanation = 'The best method is checked by default, but you can change if it fails.';  //to translate
?>