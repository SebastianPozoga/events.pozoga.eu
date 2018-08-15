<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Presentations</title>
	<script defer="defer" type="text/javascript" src="http://uvr.usabilitytools.com/uvr.js?id=1340006794"></script>
        <meta name="description" content="The HTML5 Herald"/>
        <meta name="author" content="Sebastian Pożoga"/>
        <link rel="stylesheet" href="css/styles.css?v=1.0"/>
        <style>
            *{
                margin:0px;
                padding:0px;
            }
            body{
                background-image:url("bg<?= rand(1, 4) ?>.jpg");
                background-position: center;
                background-size:cover;
                background-repeat:no-repeat;
            }
            a{
                color:black;
		text-decoration:none;
		font-weight:bold;
            }
            #container{
                text-align: center;
            }
            #list{
                display: inline-block;
                margin:100px auto;
                padding: 20px;
                background-image:url('whitealpha.png');
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .fav{
                max-width: 400px;
                max-height: 400px;
            }
        </style>
    </head>
    <body>
        <div id="container">
            <div id="list">
                <?php if ($handle = opendir('./')): ?>
                    <?php while (false !== ($entry = readdir($handle))): ?>
                        <?php if (($entry != "." && $entry != ".." && $entry != "cgi-bin") && is_dir($entry)): ?>
                            <a href="./<?= $entry ?>">
                                <div class="presentation">
                                    <div class="name"><?= $entry; ?></div>
                                    <img class="fav" src="<?= $entry ?>/fav.png" />
                                </div>
                            </a>
                        <?php endif; ?>
                    <?php endwhile; ?>
                <?php
                endif;
                closedir($handle);
                ?>
            </div>
        </div>

   <!-- analytic -->
   <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-36477444-1', 'auto');
  ga('send', 'pageview');

</script>
 
   </body>
</html>
