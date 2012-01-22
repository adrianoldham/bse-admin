package Constants;
use strict;

our $VERSION = "1.002";

# this needs to be re-organized
use vars qw(@EXPORT_OK %EXPORT_TAGS @ISA $VERSION 
$DSN $DBOPTS $DBCLASS $UN $PW $D_00 $D_99 $D_XX
$IMAGEDIR $SEP %LEVEL_DEFAULTS $BASEDIR
$MAXPHRASE $CONTENTBASE $SHOPID $PRODUCTPARENT $DATADIR $LINK_TITLES 
@SEARCH_EXCLUDE @SEARCH_INCLUDE $SEARCH_LEVEL $SEARCH_ALL
$SEARCH_WILDCARD_MIN $SEARCH_AUTO_WILDCARD $SEARCH_TITLE $SEARCH_TITLE_IMAGE
@NO_DELETE
$SHOP_MAIL_SUBJECT $SHOP_PASSPHRASE $SHOP_CRYPTO $SHOP_SIGNING_ID
$SHOP_GPG $SHOP_PGP $SHOP_FROM $SHOP_TO_NAME $SHOP_TO_EMAIL
$SHOP_PGPE $SHOP_EMAIL_ORDER %SHOP_PRODUCT_OPTS
$ROOT_URI $ARTICLE_URI $SHOP_URI $CGI_URI $ADMIN_URI $IMAGES_URI
$LOCAL_FORMAT $GENERATE_BUTTON $AUTO_GENERATE
$DATA_EMAIL $MYSQLDUMP $BODY_EMBED $EMBED_MAX_DEPTH $REPARENT_UPDOWN
$HAVE_HTML_PARSER $UNLISTED_LEVEL1_IN_CRUMBS);

$VERSION = 0.1;

require Exporter;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/$DSN $DBOPTS $DBCLASS $UN $PW $D_00 $D_99 $D_XX $SEP
$IMAGEDIR %LEVEL_DEFAULTS $BASEDIR $MAXPHRASE 
$CONTENTBASE $SHOPID $PRODUCTPARENT $DATADIR $LINK_TITLES 
@SEARCH_EXCLUDE @SEARCH_INCLUDE $SEARCH_LEVEL $SEARCH_ALL
$SEARCH_WILDCARD_MIN $SEARCH_AUTO_WILDCARD $SEARCH_TITLE $SEARCH_TITLE_IMAGE
@NO_DELETE
$SHOP_MAIL_SUBJECT $SHOP_PASSPHRASE $SHOP_CRYPTO 
$SHOP_SIGNING_ID $SHOP_GPG $SHOP_PGP $SHOP_FROM %SHOP_PRODUCT_OPTS 
$SHOP_TO_NAME $SHOP_TO_EMAIL $SHOP_EMAIL_ORDER $SHOP_PGPE
$ROOT_URI $ARTICLE_URI $SHOP_URI $CGI_URI $ADMIN_URI $IMAGES_URI
$LOCAL_FORMAT $GENERATE_BUTTON $AUTO_GENERATE
$DATA_EMAIL $MYSQLDUMP $BODY_EMBED $EMBED_MAX_DEPTH $REPARENT_UPDOWN
$HAVE_HTML_PARSER $UNLISTED_LEVEL1_IN_CRUMBS/;

%EXPORT_TAGS =
  (
   shop=> [ qw/$SHOP_MAIL_SUBJECT $SHOP_PASSPHRASE $SHOP_CRYPTO 
               $SHOP_SIGNING_ID $SHOP_GPG $SHOP_PGP $SHOP_FROM 
               $SHOP_TO_NAME $SHOP_TO_EMAIL $SHOP_PGPE
               $SHOP_EMAIL_ORDER $SHOP_URI %SHOP_PRODUCT_OPTS/ ],
   edit=> [ qw/$IMAGEDIR $D_00 $D_99 @NO_DELETE 
               $ARTICLE_URI $CGI_URI $SHOP_URI $ROOT_URI
	       $AUTO_GENERATE $REPARENT_UPDOWN/ ],
   search => [ qw/@SEARCH_EXCLUDE @SEARCH_INCLUDE $SEARCH_ALL
                  $SEARCH_WILDCARD_MIN $SEARCH_AUTO_WILDCARD/ ],
   #email => [ qw/$SMTP_SERVER $SMTP_HELO $SHOP_SENDMAIL/ ],
  );

$DSN = 'dbi:mysql:example_bse';
$DBCLASS = 'BSE::DB::Mysql';
$DBOPTS = {};
#$DSN = 'dbi:ODBC:your_dsn';
#$DBCLASS = 'BSE::DB::MSSQL';
#$DBOPTS = { LongReadLen => 200000, LongTruncOk=>1 };

$UN = 'example_bse';
$PW = 'adz17z';

# base directory of the site
$BASEDIR = '/home/example';
#$BASEDIR = 'c:/your_site';

# where we keep templates
# $TMPLDIR = $BASEDIR.'/templates/';

# where the html is kept
# set public_html in [paths] instead
$CONTENTBASE = $BASEDIR.'/public_html/';

# where we keep images
$IMAGEDIR = $CONTENTBASE.'images/';

# where we keep some data files (like stopwords.txt)
$DATADIR = $BASEDIR.'/data/';

# how the outside world sees our site
# obsolete
#$URLBASE = "http://bse.earth";
#$SECURLBASE = "http://sec.bse.earth";

# the base directories for articles and the shop
# relative to $CONTENTBASE except for $CGI_URI
# you shouldn't need to modify these
$ROOT_URI = '/';
$ARTICLE_URI = $ROOT_URI."a";
$SHOP_URI = $ROOT_URI."shop";
$ADMIN_URI = $ROOT_URI."admin/";
$IMAGES_URI = $ROOT_URI."images";
$CGI_URI = "/cgi-bin";

# level defaults
%LEVEL_DEFAULTS =
  (
   0=>{
       display=>"Example",
      },

   1=>{
       threshold=>1,
       template=>'common/default.tmpl',
       display=>'Page Lev1',
      },
   2=>{
       threshold=>1,
       template=>'common/default.tmpl',
       display=>'Page Lev2',
      },
   3=>{
       threshold=>1,
       template=>'common/default.tmpl',
       display=>'Page Lev3',
      },
   4=>{
       threshold=>1,
       template=>'common/default.tmpl',
       display=>'Page Lev4',
      },
   5=>{
       threshold=>1,
       template=>'common/default.tmpl',
       display=>"Page Lev5",
      },
  );

# set this to zero to disable adding titles to the end of links
# eg. with this on, if article id 5 has a title of "hello world", then
# links to it will be: /a/5.html/hello_world
# the aim of this is if a search engine indexes on the url, it has something
# useful to index on
# To make this work with Apache, put the following in the .htaccess file
# in the /a/ directory:
#   RewriteEngine On
#   RewriteRule ^([0-9]+\.html)/[0-9a-zA-Z_]*$ ./$1 [T=text/html]
$LINK_TITLES = 0;

# sections to exclude from the search
@SEARCH_EXCLUDE = (6);

# sections to include in the search section drop-down, even if unlisted
@SEARCH_INCLUDE = ();

# any articles with a higher level than this are indexed as their ancestor 
# at this level
$SEARCH_LEVEL = 5;

# used to mean "all of site" in the search section drop-down
$SEARCH_ALL = "All Sections";

# non-zero to allow automatic wildcard searches
$SEARCH_AUTO_WILDCARD = 1;

# the minimum length of a wildcard search term
$SEARCH_WILDCARD_MIN = 4;

# the title used for the artificial article used to generate the 
# search base page
$SEARCH_TITLE = "Search";

# the title image used for the artificial article used to generate
# the search base page
$SEARCH_TITLE_IMAGE = "";

# articles that cannot be deleted
# you don't need to include the shop ids here, they are always 
# protected
# This is deprecated, use [undeletable articles] instead
@NO_DELETE = ( 1, 2, 3, 4, 5, 6, 7 );

# you can use the following to add local body formatting tags without
# having to modify Generate.pm and give yourself upgrade hassles
# the following should be a reference blessed into class with two methods:
#   body(\$body) - substitute your tags, return true if any tags replaced
#   clean(\$body) - remove any tags, return true if any tags replaced
$LOCAL_FORMAT = undef;

# controls whether or not the embed[] tags works in article bodies
$BODY_EMBED = 0;

# the maximum number of embedding levels
$EMBED_MAX_DEPTH = 20;

# controls whether or not the Regenerate button is displayed
# also whether generate.pl actually does something
# For normal scalars, non-zero means the button is displayed
# for a coderef, if a call to the coderef returns non-zero the button is 
# display
# for any other ref, if $GENERATE_BUTTON->want_button() is non-zero then
# the button is displayed
# you could assign a coderef that checks if the current user is
# in an admin group
$GENERATE_BUTTON = 1;

# if this is non-zero an articles and its ancestors are regenerated
# when the article is modified
$AUTO_GENERATE = 1;

# if this is non-zero then the user can reparent the article to a 
# different level
# this can be a coderef if you want, which returns non-zero if the
# user can reparent up/down
$REPARENT_UPDOWN = 1;

# if this is non-zero then by default the level 1 ancestor of an article
# will be listed in it's crumbs
# this can be overridden with the 'listedonly' and 'showtop' options
# for the <:iterator begin crumbs:> tag
$UNLISTED_LEVEL1_IN_CRUMBS = 0;

# this should be non-zero if you have HTML::Parser installed
# if non-zero then HTML::Parser will be used to strip HTML tags
# from <HTML> bodies and from html[] tags in bodies when the text is
# being displayed in either a table of contents summary or in 
# a search result excerpt.  It is also used to extract test for search
# indexing
$HAVE_HTML_PARSER = 1;

# shop configuration

# the cryto module used to encrypt your copy of the order
# this can also be Squirrel::PGP5 or Squirrel::PGP6, at least if they
# work...
$SHOP_CRYPTO = 'Squirrel::GPG';

# the passphrase for the secret key used to sign your copy of the order
$SHOP_PASSPHRASE = "";

# the id of the key
#$SHOP_SIGNING_ID = '0x00000000';
$SHOP_SIGNING_ID = '';

# the path to the gpg program (if it isn't in the PATH)
# (only for Squirrel::GPG)
$SHOP_GPG = '/usr/bin/gpg';
#$SHOP_GPG = '/usr/local/bin/gpg';

# the path to the pgp program (if it isn't in the PATH)
# (only for Squirrel::PGP6)
$SHOP_PGP = 'pgp';

# the path to the pgpe program (if it isn't in the PATH)
# (only for Squirrel::PGP5)
$SHOP_PGPE = 'pgpe';

# where to find sendmail (or something compatible)
#$SHOP_SENDMAIL = '/usr/lib/sendmail';

# subject for the email sent to customers upon filling in an order
$SHOP_MAIL_SUBJECT = "Your (web site) order";

# name used in the From line for both the order emails
$SHOP_FROM = '';

# the name/email your copy of emailled orders should be sent to
$SHOP_TO_NAME = '';
$SHOP_TO_EMAIL = '';

# non-zero if we should email an encrypted order to $SHOP_TO_EMAIL
$SHOP_EMAIL_ORDER = 1;

# possible extra options for a product
##START_PRODUCT_OPTS
%SHOP_PRODUCT_OPTS =
  (
   msize =>
   {
    values=>[ qw(S M L XL XXL) ],
    labels=> 
    {
     S=>'Small', 
     M=>'Medium', 
     L=>'Large', 
     XL=>'Extra Large', 
     XXL=>'Extra Extra Large'
    },
    default=>'L',
    desc=>'Size'
   },
   wsize=>
   {
    desc=>'Size',
    values=>[ qw(8 10 12 14 16 18) ],
   },
   mcolors=>
   {
    desc=>'Colour',
    values=>[ qw(Red Blue Green) ],
   },
   wcolors=>
   {
    desc=>'Colour',
    values=>[ qw(Pink Aqua Maroon) ],
   },
   capsize=>
   {
    desc=>"Size",
    values=>[ qw(Small Large) ]
   },
   capcolour=>
   {
    desc=>"Colour",
    values => [ qw(Red Black White) ],
   },
  );
##END_PRODUCT_OPTS

# Maintenance tools

# datadump.pl emails the dump to this address
#$DATA_EMAIL = 'you@yoursite.com';
$DATA_EMAIL = '';

# the name of your copy of mysqldump (used by datadump.pl)
# if it's not in the PATH then give the absolute path here
$MYSQLDUMP = 'mysqldump';

###########################################################
### *** You should not need to modify the following *** ###
###########################################################

# maximum phrase length indexed
$MAXPHRASE = 5;

# the article (section) which is the online-store
# used to link to the shop
$SHOPID = 3;

# article that acts as the parent for products
# this must be the only child of $SHOPID
$PRODUCTPARENT = 4;


$SEP = "\x01";

$D_00 = '0000-00-00 00:00:00' ;
$D_99 = '9999-12-31 23:59:59' ;

use POSIX qw/strftime/; 
$D_XX = sub { strftime "%Y-%m-%d %H:%M:%S" => (localtime)[0..5] };

# %TEMPLATE_OPTS = ( template_dir => $TMPLDIR );


1;
