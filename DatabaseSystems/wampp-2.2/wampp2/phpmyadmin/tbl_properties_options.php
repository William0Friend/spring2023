<?php
/* $Id: tbl_properties_options.php,v 1.22 2003/04/14 13:24:47 nijel Exp $ */
// vim: expandtab sw=4 ts=4 sts=4:


/**
 * Runs common work
 */
require('./tbl_properties_common.php');
$url_query .= '&amp;goto=tbl_properties_options.php&amp;back=tbl_properties_options.php';


/**
 * Updates table comment, type and options if required
 */
if (isset($submitcomment)) {
    if (empty($prev_comment) || urldecode($prev_comment) != $comment) {
        $sql_query = 'ALTER TABLE ' . PMA_backquote($table) . ' COMMENT = \'' . PMA_sqlAddslashes($comment) . '\'';
        $result    = PMA_mysql_query($sql_query) or PMA_mysqlDie('', $sql_query, '', $err_url);
        $message   = $strSuccess;
    }
}
if (isset($submittype)) {
    $sql_query     = 'ALTER TABLE ' . PMA_backquote($table) . ' TYPE = ' . $tbl_type;
    $result        = PMA_mysql_query($sql_query) or PMA_mysqlDie('', $sql_query, '', $err_url);
    $message       = $strSuccess;
}
if (isset($submitoptions)) {
    $sql_query     = 'ALTER TABLE ' . PMA_backquote($table)
                   . (isset($pack_keys) ? ' pack_keys=1': ' pack_keys=0')
                   . (isset($checksum) ? ' checksum=1': ' checksum=0')
                   . (isset($delay_key_write) ? ' delay_key_write=1': ' delay_key_write=0')
                   . (isset($auto_increment) ? ' auto_increment=' . PMA_sqlAddslashes($auto_increment) : '');
    $result        = PMA_mysql_query($sql_query) or PMA_mysqlDie('', $sql_query, '', $err_url);
    $message       = $strSuccess;
}

// Displays a message if a query had been submitted
if (isset($message)) {
    PMA_showMessage($message);
}

/**
 * Gets tables informations and displays top links
 */
require('./tbl_properties_table_info.php');

/**
 * Displays form controls
 */
if (PMA_MYSQL_INT_VERSION >= 32322) {
    ?>
<ul>
    <!-- Table comments -->
    <li>
        <form method="post" action="tbl_properties_options.php">
            <?php echo PMA_generate_common_hidden_inputs($db, $table); ?>
            <?php echo $strTableComments; ?>&nbsp;:&nbsp;
            <?php $comment = ereg_replace('; InnoDB free:[^;]*$' , '', ereg_replace('^InnoDB free:[^;]*$', '', $show_comment)); ?>
            <input type="hidden" name="prev_comment" value="<?php echo urlencode($comment); ?>" />&nbsp;
            <input type="text" name="comment" maxlength="60" size="30" value="<?php echo htmlspecialchars($comment); ?>" class="textfield" style="vertical-align: middle" onfocus="this.select()" />&nbsp;
            <input type="submit" name="submitcomment" value="<?php echo $strGo; ?>" style="vertical-align: middle" />
        </form>
    </li>

    <!-- Table type -->
    <?php
    // modify robbat2 code - staybyte - 11. June 2001
    $query  = 'SHOW VARIABLES LIKE \'have_%\'';
    $result = PMA_mysql_query($query);
    if ($result != FALSE && mysql_num_rows($result) > 0) {
        while ($tmp = PMA_mysql_fetch_array($result)) {
            if (isset($tmp['Variable_name'])) {
                switch ($tmp['Variable_name']) {
                    case 'have_bdb':
                        if ($tmp['Value'] == 'YES') {
                            $tbl_bdb    = TRUE;
                        }
                        break;
                    case 'have_gemini':
                        if ($tmp['Value'] == 'YES') {
                            $tbl_gemini = TRUE;
                        }
                        break;
                    case 'have_innodb':
                        if ($tmp['Value'] == 'YES') {
                            $tbl_innodb = TRUE;
                        }
                        break;
                    case 'have_isam':
                        if ($tmp['Value'] == 'YES') {
                            $tbl_isam   = TRUE;
                        }
                        break;
                } // end switch
            } // end if isset($tmp['Variable_name'])
        } // end while
    } // end if $result

    mysql_free_result($result);
    echo "\n";
    ?>
    <li>
        <form method="post" action="tbl_properties_options.php">
            <?php echo PMA_generate_common_hidden_inputs($db, $table); ?>
            <?php echo $strTableType; ?>&nbsp;:&nbsp;
            <select name="tbl_type" style="vertical-align: middle">
                <option value="MYISAM"<?php if ($tbl_type == 'MYISAM') echo ' selected="selected"'; ?>>MyISAM</option>
                <option value="HEAP"<?php if ($tbl_type == 'HEAP') echo ' selected="selected"'; ?>>Heap</option>
    <?php
    $tbl_types     = "\n";
    if (isset($tbl_bdb)) {
        $tbl_types .= '                <option value="BDB"'
                   .  (($tbl_type == 'BERKELEYDB') ? ' selected="selected"' : '')
                   .  '>Berkeley DB</option>' . "\n";
    }
    if (isset($tbl_gemini)) {
        $tbl_types .= '                <option value="GEMINI"'
                   .  (($tbl_type == 'GEMINI') ? ' selected="selected"' : '')
                   .  '>Gemini</option>' . "\n";
    }
    if (isset($tbl_innodb)) {
        $tbl_types .= '                <option value="INNODB"'
                   .  (($tbl_type == 'INNODB') ? ' selected="selected"' : '')
                   .  '>INNO DB</option>' . "\n";
    }
    if (isset($tbl_isam)) {
        $tbl_types .= '                <option value="ISAM"'
                   .  (($tbl_type == 'ISAM') ? ' selected="selected"' : '')
                   .  '>ISAM</option>' . "\n";
    }

    echo $tbl_types;
    ?>
                <option value="MERGE"<?php if ($tbl_type == 'MRG_MYISAM') echo ' selected="selected"'; ?>>Merge</option>
            </select>&nbsp;
            <input type="submit" name="submittype" value="<?php echo $strGo; ?>" style="vertical-align: middle" />&nbsp;
            <?php echo PMA_showMySQLDocu('Table_types', 'Table_types') . "\n"; ?>
        </form>
    </li>

    <!-- Table options -->
    <li style="vertical-align: top">
        <table border="0" cellspacing="0" cellpadding="0" style="vertical-align: top">
        <tr>
            <td valign="top">
                <form method="post" action="tbl_properties_options.php">
                    <?php echo PMA_generate_common_hidden_inputs($db, $table); ?>

                    <table border="0" cellspacing="1" cellpadding="1">
                    <tr>
                        <td align="right"><input type="checkbox" name="pack_keys" id="pack_keys_opt"
                                <?php echo (isset($pack_keys) && $pack_keys == 1) ? ' checked="checked"' : ''; ?> /></td>
                        <td><label for="pack_keys_opt">pack_keys</label>&nbsp;&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="right"><input type="checkbox" name="checksum" id="checksum_opt"
                                <?php echo (isset($checksum) && $checksum == 1) ? ' checked="checked"' : ''; ?> /></td>
                         <td><label for="checksum_opt">checksum</label>&nbsp;&nbsp;</td>
                    </tr>
                    <tr>
                         <td align="right"><input type="checkbox" name="delay_key_write" id="delay_key_write_opt"
                                <?php echo (isset($delay_key_write) && $delay_key_write == 1) ? ' checked="checked"' : ''; ?> /></td>
                         <td><label for="delay_key_write_opt">delay_key_write</label>&nbsp;&nbsp;</td>
                    </tr>
                    <tr>
                         <td><input type="text" name="auto_increment" id="auto_increment_opt" class="textfield" style="width: 30px"
                                <?php echo (isset($auto_increment) && !empty($auto_increment) ? ' value="' . $auto_increment . '"' : ''); ?> /></td>
                         <td valign="top"><label for="auto_increment_opt">auto_increment</label>&nbsp;&nbsp;<input type="submit" name="submitoptions" value="<?php echo $strGo; ?>" /></td>
                    </tr>
                    </table>
                </form>
            </td>
        </tr>
        </table>
    </li>
</ul>
    <?php
} // end if (PMA_MYSQL_INT_VERSION >= 32322)


/**
 * Displays the footer
 */
echo "\n";
require('./footer.inc.php');
?>
