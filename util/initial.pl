#!/usr/bin/perl -w
# Builds an initial database
# make sure you set the appropriate values in cgi-bin/modules/Constants.pm

use strict;
use lib '../cgi-bin/modules';
use DBI;
use BSE::TB::Article;
use Constants qw($DSN $UN $PW $CGI_URI $SHOP_URI $ROOT_URI);
use BSE::API qw(bse_init bse_cfg);
use BSE::Util::SQL qw(now_sqldate now_sqldatetime);

bse_init("../cgi-bin");
my $cfg = bse_cfg();
my $securlbase = $cfg->entryVar('site', 'secureurl');
my $secureurl_articles = $cfg->entryVar('shop', 'secureurl_articles');
my $nowDate = now_sqldate();
my $nowDatetime = now_sqldatetime();

if ($secureurl_articles == 0) {
   $securlbase = '';
}

my @prebuilt =
  (
   # the section that represent's the index page
   {
    id => 1,
    parentid => -1,
    displayOrder => 30000, # doesn't matter
    title => 'Home',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => '',
    template => 'index.tmpl',
    link => $ROOT_URI . '',
    admin => $CGI_URI.'/admin/admin.pl?id=1',
    threshold => 10000, # needs to be high
    summaryLength => 0, # should be ignored
    generator => 'BSE::Generate::Article',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 1,
    listed => 1,
    flags => '',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => '',
    category => '',
   },
   {
    id => 2,
    parentid => 1,
    displayOrder => 29000,
    title => '[aside]',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => '',
    template => 'sidebar/section.tmpl',
    link => '',
    admin => $CGI_URI.'/admin/admin.pl?id=2',
    threshold => 10000, # needs to be high
    summaryLength => 0, # should be ignored
    generator => 'BSE::Generate::Article',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 2,
    listed => 0,
    flags => 'ND',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => '',
    category => '',
   },
   {
    id => 3,
    parentid => -1,
    displayOrder => 26000,
    title => 'Shop',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => 'shop',
    template => 'common/default.tmpl',
    link => $securlbase.$SHOP_URI.'/',
    admin => $CGI_URI.'/admin/admin.pl?id=3',
    threshold => 1, # ignored
    summaryLength => 0, # ignored
    generator => 'BSE::Generate::Catalog',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 1,
    listed => 1,
    flags => '',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => 'shop',
    category => '',
   },
   {
    id => 6,
    parentid => -1,
    displayOrder => 21000,
    title => 'Sitemap',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => '',
    template => 'sitemap.tmpl',
    link => '/a/6.html',
    admin => $CGI_URI.'/admin/admin.pl?id=6',
    threshold => 0, # ignored
    summaryLength => 0, #ignored
    generator => 'BSE::Generate::Article',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 1,
    listed => 1,
    flags => 'N',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => 'sitemap',
    category => '',
   },
   {
    id => 7,
    parentid => -1,
    displayOrder => 27000,
    title => 'About',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => '',
    template => 'common/default.tmpl',
    link => '/a/7.html',
    admin => $CGI_URI.'/admin/admin.pl?id=7',
    threshold => 0, # ignored
    summaryLength => 0, #ignored
    generator => 'BSE::Generate::Article',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 1,
    listed => 1,
    flags => '',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => 'about',
    category => '',
   },
   {
    id => 8,
    parentid => -1,
    displayOrder => 22000,
    title => 'Contact',
    titleImage => '',
    body => '',
    imagePos => 'tr',
    release => "$nowDate 00:00:00",
    expire => '9999-12-31 23:59:59',
    lastModified => "$nowDatetime",
    keyword => '',
    template => 'common/default.tmpl',
    link => '/a/8.html',
    admin => $CGI_URI.'/admin/admin.pl?id=8',
    threshold => 0, # ignored
    summaryLength => 0, #ignored
    generator => 'BSE::Generate::Article',
    thumbImage => '',
    thumbWidth => 0,
    thumbHeight => 0,
    level => 1,
    listed => 1,
    flags => '',
    lastModifiedBy => 'system',
    created => "$nowDatetime",
    createdBy => 'system',
    author => '',
    pageTitle => '',
    force_dynamic => 0,
    cached_dynamic => 0,
    inherit_siteuser_rights => 1,
    metaDescription => '',
    metaKeywords => '',
    summary => '',
    menu => 0,
    titleAlias => '',
    linkAlias => 'contact',
    category => '',
   },
  );

my $dbh = BSE::DB->single->dbh
  or die "Cannot connect to database: ",DBI->errstr;
my @columns = BSE::TB::Article->columns;
$dbh->do('delete from article')
  or die "Cannot delete articles: ",$dbh->errstr;
$dbh->do('delete from product')
  or die "Cannot delete from product: ", $dbh->errstr;
$dbh->do('delete from image')
  or die "delete from image: ",$dbh->errstr;
my $sql = 'insert into article values('.join(',', ('?') x @columns).')';
my $sth = $dbh->prepare($sql)
  or die "Cannot prepare $sql: ",$dbh->errstr;
for my $art (@prebuilt) {
  defined $art->{linkAlias} or $art->{linkAlias} = '';
  $sth->execute(@$art{@columns})
    or die "Cannot insert row into article: ",$sth->errstr;
}
$dbh->disconnect();
