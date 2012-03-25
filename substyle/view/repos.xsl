<?xml version="1.0"?>
<!--
Repos Style (c) 2004-2009 Staffan Olsson reposstyle.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

  ==== reposstyle.com: Subversion folder index style ====
  The logic for this stylesheet, commandbar, id-generation,
  folderPathLinks and filetypes are all ideas from repos.se.

  To be used as SVNIndexXSLT in repository conf.
  Used at all directory levels, so urls must be absolute.
  Note that browser transformations only work if the
  stylesheet is read from the same domain as the XML
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
	<xsl:output method="html" encoding="utf-8" omit-xml-declaration="no" indent="no"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<xsl:param name="reposstyle-version">2.4</xsl:param>

	<!-- === repos style configuration === -->
	<!-- static: absolute url to style application -->
	<xsl:param name="static">/reposstyle/substyle/</xsl:param>
	<!-- cssUrl: absolute url to css folder -->
	<xsl:param name="cssUrl"><xsl:value-of select="$static"/>style/</xsl:param>
	<!-- logUrl: empty -> no log tool, absolute url -> enable 'history' link. Must allow appended query param -->
	<xsl:param name="logUrl">/projects/<xsl:value-of select="/svn/index/@base"/>/repository/changes</xsl:param>
	<!-- startpage: empty -> standard behaviour, absolute url -> special handling of 'up' from trunk -->
	<xsl:param name="startpage">/svn/<xsl:value-of select="/svn/index/@base"/></xsl:param>
	<!-- tools: name of recognized top level folders to get css tool-class -->
	<xsl:param name="tools">/trunk/branches/tags/</xsl:param>
	<!-- ===== end of configuration ===== -->

	<xsl:param name="spacer" select="' &#160; '"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:text>repos: </xsl:text>
					<xsl:value-of select="/svn/index/@base"/>
					<xsl:value-of select="/svn/index/@path"/>
				</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta name="robots" content="noarchive"/>
				<link rel="shortcut icon" href="/favicon.ico"/>
				<xsl:call-template name="styletag"/>
				<!-- repos metadata for use in plugins -->
				<meta name="repos-service" content="index/" />
				<meta name="repos-target" content="{/svn/index/@path}/" />
				<meta name="repos-base" content="{/svn/index/@base}" />
				<!-- plugins -->
				<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css" />
                                <script src="http://code.jquery.com/jquery-1.7.1.js"></script>
                                <script src="http://code.jquery.com/mobile/1.0.1/jquery.mobile-1.0.1.js"></script>
				
			</head>
			<body class="repository xml">
				<xsl:apply-templates select="svn"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="styletag">
		<link rel="stylesheet" type="text/css" media="screen,projection" href="{$cssUrl}mobile.css"/>
		<!--<link rel="stylesheet" type="text/css" media="screen,projection" href="{$cssUrl}repository/repository.css"/>-->
	</xsl:template>
	<xsl:template match="svn">
		<xsl:apply-templates select="index"/>
	</xsl:template>
	<xsl:template match="index">
		<div id="workspace" data-role="page">
			<!-- <xsl:call-template name="commandbar"/> -->
			<xsl:call-template name="contents"/>
			<xsl:call-template name="footer"/>
		</div>
	</xsl:template>
	<xsl:template name="commandbar">
                <div id="headernah">
		<div id="commandbar">
		<xsl:if test="$startpage">
			<a id="home" rel="external" class="command translate" href="{$startpage}"><span>home</span></a>
		</xsl:if>
		<!-- <xsl:if test="/svn/index/updir"> -->
			<a id="parent" class="command translate" href="../"><span>up</span></a>
		<!-- </xsl:if> -->
		<!-- <xsl:if test="$logUrl"> add @rev>0 to hide log for SVNParentPath and empty repositories -->
		<xsl:if test="$logUrl and @rev>0">
			<a id="history" class="command translate" href="{$logUrl}{/svn/index/@path}"><span>folder history</span></a>
		</xsl:if>
		<a id="refresh" class="command translate" href="#" onclick="window.location.reload( true )"><span>refresh</span></a>
                <!-- <xsl:param name="fullpath" select="concat(/svn/index/@path,'/')"/>
                <h1>
                <xsl:call-template name="getFolderPathLinks">
                     <xsl:with-param name="folders" select="$fullpath"/>
                </xsl:call-template>
                </h1> -->
                </div>
                </div>
	</xsl:template>
	<!-- directory listing -->
	<xsl:template name="contents">
		<xsl:param name="fullpath" select="concat(/svn/index/@path,'/')"/>
                <div id="header" data-role="header" data-position="inline">
                <!-- <xsl:if test="$startpage">
                    <a id="home" rel="external" data-role="button" href="{$startpage}"  data-icon="home">Home</a>
                </xsl:if> -->

                <div data-role="controlgroup" data-type="horizontal">
                <a href="{$startpage}" data-role="button" data-icon="home" rel="external"><xsl:value-of select="/svn/index/@base"/>
                    <xsl:if test="@rev">
                        <xsl:value-of select="$spacer"/>
                                <span class="revision">
                                        (<xsl:value-of select="@rev"/>)
                                </span>
                    </xsl:if>
                </a>
                        <xsl:call-template name="getFolderPathLinks">
                                <xsl:with-param name="folders" select="$fullpath"/>
                        </xsl:call-template>
                </div>
                </div>
                <div data-role="navbar">
                <ul>
                <xsl:if test="/svn/index/updir">
                       <li><a id="parent" rel="external" class="command translate" data-icon="arrow-u" href="../"><span>Up</span></a></li>
                </xsl:if>

                <li><a id="refresh" rel="external" data-role="button"  data-icon="refresh" href="#" onclick="window.location.reload( true )">refresh</a></li>

                <xsl:if test="$logUrl and @rev>0">
                       <li><a id="history" rel="external" data-icon="info"  href="{$logUrl}{/svn/index/@path}"><span>Redmine history</span></a></li>
                </xsl:if>
                </ul>
                </div>
                <div id="main" data-role="content">
                  <ul data-role="listview" data-filter="true">
			<xsl:apply-templates select="dir">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="file">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
                    </ul>
                </div>
	</xsl:template>
	<xsl:template match="dir">
		<xsl:param name="id">
			<xsl:call-template name="getFileID"/>
		</xsl:param>
		<xsl:param name="n" select="position() - 1"/>
		<li id="row:{$id}" class="n{$n mod 4}">
                        <a id="f:{$id}" class="folder" href="{@href}" rel="external">
                        <img src="/reposstyle/substyle/style/folder32.png" class="ui-li-icon" style="top:0.2em;left:6px;" />
                                <xsl:value-of select="@name"/>
                                <!-- <xsl:value-of select="'/'"/> -->
                        </a>

		</li>
	</xsl:template>
	<xsl:template match="file">
		<xsl:param name="filetype">
			<xsl:call-template name="getFiletype"/>
		</xsl:param>
		<xsl:param name="id">
			<xsl:call-template name="getFileID"/>
		</xsl:param>
		<xsl:param name="n" select="count(/svn/index/dir) + position() - 1"/>
		<li id="row:{$id}" class="n{$n mod 4}" data-icon="arrow-d">
                        <a id="f:{$id}" class="file-{$filetype} file" rel="external" href="{@href}">
                                <xsl:value-of select="@name"/>
                        </a>

				<!-- <a id="open:{$id}" class="action" href="{@href}">open</a>-->
				<!-- <xsl:if test="$logUrl">
					<a id="history:{$id}" class="action" href="{$logUrl}changes{../@path}/{@href}">view history</a>
				</xsl:if> -->
		</li>
	</xsl:template>
	<xsl:template name="footer">
		<div id="footer" data-role="footer">
		<h4><span>Revision <span class="revision"><xsl:value-of select="@rev"/></span> - </span>
		<span><a href="http://www.reposstyle.com/" target="_blank">Repos&#160;Style</a>&#160;<xsl:value-of select="$reposstyle-version"/>
		&amp; <a href="http://jquerymobile.com/" target="_blank">jQueryMobile</a></span>&#160;
		<span id="badges">
		</span>
		<span class="legal">
		<xsl:text>Powered by </xsl:text>
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="../@href"/></xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute>
			<xsl:text>Subversion</xsl:text>
		</xsl:element>
		<xsl:text>&#160;</xsl:text>
		<xsl:value-of select="../@version"/>
		<xsl:text>&#160;</xsl:text>
		</span>
                </h4>
		</div>
	</xsl:template>
	<xsl:template name="getFolderPathLinks">
		<xsl:param name="folders"/>
		<xsl:param name="f" select="substring-before($folders, '/')"/>
		<xsl:param name="rest" select="substring-after($folders, concat($f,'/'))"/>
		<xsl:param name="return">
			<xsl:call-template name="getReverseUrl">
				<xsl:with-param name="url" select="$rest"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="classadd">
			<xsl:choose>
				<xsl:when test="contains($tools,concat('/',$f,'/'))">
					<xsl:value-of select="concat(' tool tool-',$f)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="' project'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="id">
			<xsl:call-template name="getFileID">
				<xsl:with-param name="filename" select="$return"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:if test="not(string-length($rest)>0)">
                        <xsl:if test="string($f)"> 
			<span id="folder" class="path{$classadd}">
				<span data-role="button"><xsl:value-of select="$f"/></span>
			</span>
			<!-- trailing slash: <span class="separator"><xsl:value-of select="'/'"/></span> -->
                        </xsl:if>
		</xsl:if>
		<xsl:if test="string-length($rest)>0">
                        <xsl:if test="string($f)">
			<a id="{$id}" href="{$return}" class="path{$classadd}" data-role="button" rel="external">
				<xsl:value-of select="$f"/>
			</a>
                        </xsl:if>
			<!-- <span class="separator"><xsl:value-of select="'/'"/></span>-->
			<xsl:if test="$classadd=' project'">
				<xsl:call-template name="getFolderPathLinks">
					<xsl:with-param name="folders" select="$rest"/>
				        <xsl:with-param name="return" select="substring-after($return,'/')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$classadd!=' project'">
				<xsl:call-template name="getFolderPathLinks">
					<xsl:with-param name="folders" select="$rest"/>
					<xsl:with-param name="return" select="substring-after($return,'/')"/>
					<xsl:with-param name="classadd" select="''"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getReverseUrl">
		<xsl:param name="url"/>
		<xsl:if test="contains($url,'/')">
			<xsl:value-of select="'../'"/>
			<xsl:call-template name="getReverseUrl">
				<xsl:with-param name="url" select="substring-after($url,'/')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getFiletype">
		<xsl:param name="filename" select="@href"/>
		<xsl:variable name="type" select="substring-after($filename,'.')"/>
		<xsl:choose>
			<xsl:when test="$type">
				<xsl:call-template name="getFiletype">
					<xsl:with-param name="filename" select="$type"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
				<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
				<xsl:value-of select="translate($filename,$ucletters,$lcletters)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getFileID">
		<xsl:param name="filename" select="@href"/>
		<xsl:value-of select="translate($filename,'%/','__')"/>
	</xsl:template>
	<xsl:template name="linebreak">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&#10;')">
				<xsl:value-of select="substring-before($text, '&#10;')"/>
				<br/>
				<xsl:call-template name="linebreak">
					<xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
