
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"> 
 
<head> 
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
 
     <title>One Page Resume</title> 
 
     <style type="text/css"> 
        * { margin: 0; padding: 0; }
        body { font: 16px Helvetica, Sans-Serif; line-height: 24px; }
        .clear { clear: both; }
        #page-wrap { width: 800px; margin: 40px auto 60px; }
        #pic { float: right; margin: -30px 0 0 0; }
        h1 { margin: 0 0 16px 0; padding: 0 0 16px 0; font-size: 42px; font-weight: bold; border-bottom: 1px solid #999; }
        h2 { font-size: 20px; margin: 0 0 6px 0; position: relative; }
        h2 span { position: absolute; bottom: 0; right: 0; font-style: italic; font-family: Georgia, Serif; font-size: 16px; color: #999; font-weight: normal; }
        p { margin: 0 0 16px 0; }
        a { color: #999; text-decoration: none; border-bottom: 1px dotted #999; }
        a:hover { border-bottom-style: solid; color: black; }
        ul { margin: 0 0 32px 17px; }
        #objective { width: 500px; float: left; }
        #objective p { font-family: Georgia, Serif; font-style: italic; color: #666; }
        dt { font-style: italic; font-weight: bold; font-size: 18px; text-align: right; padding: 0 26px 0 0; width: 150px; float: left; height: 100px; border-right: 1px solid #999;  }
        dd { width: 600px; float: right; }
        dd.clear { float: none; margin: 0; height: 15px; }
     </style> 
</head> 
 
<body> 
 
    <div id="page-wrap"> 
        <!-- <img src="images/cthulu.png" alt="Photo of Cthulu" id="pic" /> -->
        <div id="contact-info" class="vcard"> 
            <h1 class="fn">Josef N Patoprsty</h1> 
            <p> 
                Cell: <span class="tel">555-666-7777</span><br /> 
                Email: <a class="email" href="mailto:seppi@josefnpat.com">seppi@josefnpat.com</a> 
            </p> 
        </div> 
        <div id="objective"> 
            <p>
              My Objective
            </p> 
        </div> 
        <div class="clear"></div> 
        <dl> 
<?php for($i = 0; $i < 6; $i++) { ?>
            <dd class="clear"></dd> 
            <dt>Education</dt> 
            <dd> 
                <h2>Rochester Institute of Technology - Rochester, New York</h2> 
                <p><strong>Major:</strong> Computer Engineering Technology<br /> 
                   <strong>Minor:</strong> Computer Science<br />
                   <strong>Concentration:</strong> Writing Studies</p> 
            </dd> 
<?php } ?>
            <dd class="clear"></dd> 
        </dl> 
        <div class="clear"></div> 
     <small><?php echo time(); ?></small>
    </div> 

</body> 
 
</html>
