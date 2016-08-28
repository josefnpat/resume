<?php

if(!isset($argv[1])){
  die("Error: No json target supplied.\n");
}
if(!file_exists($argv[1])){
  die("Error: json target `$argv[1]` does not exist.\n");
}

$json_data = file_get_contents($argv[1]);
$data = json_decode($json_data);
$json_shared = file_get_contents("shared.json");
$shared = json_decode($json_shared);
?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo $shared->name."'s R&eacute;sum&eacute;"; ?></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="style.css" type="text/css" />
  </head>
  <body>
    <div id="pagewrap">
      <div id="github">Rendered from http://github.com/josefnpat/resume<br \><?php echo `git log --pretty=format:'%aD [git:%h]' -n 1`; ?></div>
      <div id="monster"></div>
      <div id="sidebar">
        <div id="name"><?php echo $shared->name; ?></div>
        <div id="contacts">
<?php foreach($shared->contact as $contact){ ?>
          <div class="contact">
            <ul>
<?php   foreach($contact as $line){ ?>
              <li><?php echo $line; ?></li>
<?php   } // end contact line ?>
            </ul>
          </div> <!-- end contact -->
<?php } // end contact ?>
        </div> <!-- end contacts -->
      </div> <!-- end sidebar -->
      <div id="sections">
<?php foreach($data->sections as $key => $section){ ?>
        <div class="section"> <!-- Section: <?php echo $key; ?> -->
          <div class="title"><?php echo $key; ?></div>
<?php   if(isset($section->Header)){ ?>
          <div class="header"><?php echo $section->Header; ?></div>
<?php   } // end header
        if(isset($section->Paragraph)){
          foreach($section->Paragraph as $paragraph){ ?>
          <div class="paragraph"><?php echo $paragraph; ?></div>
<?php     }
        } // end paragraph
        if(isset($section->Table)){ ?>
          <table>
<?php     foreach($section->Table as $key => $value){ ?>
            <tr>
              <td class="l"><?php echo $key; ?></td>
              <td class="r"><?php echo $value; ?></td>
            </tr>
<?php     } ?>
          </table>
<?php   } // end table
        if(isset($section->Timeline)){ ?>
          <div class="timeline">
<?php     foreach($section->Timeline as $key => $value){ ?>
            <div class="time">
              <div class="key"><?php echo $key; ?></div>
<?php         if(is_array($value)){ ?>
<?php           foreach($value as $newvalue){ ?>
                  <div class="value"><?php echo $newvalue; ?></div>
<?php           } ?>
<?php         } else { ?>
                <div class="value"><?php echo $value; ?></div>
<?php         } ?>
            </div> <!-- end time -->
<?php     } ?>
          </div> <!-- end timeline -->
<?php   } // end timeline ?>
        </div> <!-- end section -->
<?php } // end section ?>
      </div> <!-- end sections -->
    </div> <!-- end pagewrap -->
  </body>
</html>
