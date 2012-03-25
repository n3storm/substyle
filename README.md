Substyle -- subversion repositories browsed with style
======================================================

## DESCRIPTION
Substyle is a theme for Repostyle http://www.reposstyle.com that uses Jquerymobile to make browsing more smooth and useful.
For example, directories and files list can be filtered. Is specally suited for browsing Redmine managed repositories by showing a button to Redmine repository history. Fork this project to remove this in file substyle/view/repos.xsl, line 141.

## INSTALLATION
You have to follow instructions in http://www.reposstyle.com/.
When everything is working with default theme, clone or drop substyle folder inside reposstyle directory.
Also, set the following in you Apache virtualhost file:

```
<VirtualHost>
.... your settings ...
   <Directory /var/www-tools/reposstyle/>
         Order deny,allow
      allow from all
   </Directory>
   <Location /svn>
     DAV svn
     SVNListParentPath on
     SVNParentPath "/your/path/to/svn/repositories"
     ModMimeUsePathInfo on
     SVNIndexXSLT "/reposstyle/substyle/view/repos.xsl"
  </Location>
</VirtualHost>
```

## SCREENSHOT

[[docs/screenshot.png]]
