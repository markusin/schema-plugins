<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmi="http://sdi.eurac.edu/inspire/geonetwork/iso19139-2"
	xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

	<!-- main template - the way into processing iso19139-2 -->
  <xsl:template name="metadata-iso19139-2view-simple">
    <xsl:call-template name="metadata-iso19139view-simple"/>
  </xsl:template>


  <xsl:template name="view-with-header-iso19139-2">
    <xsl:param name="tabs"/>
    
    <xsl:call-template name="view-with-header-iso19139">
      <xsl:with-param name="tabs" select="$tabs"/>
    </xsl:call-template>
  </xsl:template>
  
	<xsl:template name="metadata-iso19139-2">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>
		
		<xsl:apply-templates mode="iso19139" select="." >
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded" />
		</xsl:apply-templates>
	</xsl:template>
	
	
  <xsl:template name="iso19139-2CompleteTab">
    <xsl:param name="tabLink"/>
    <xsl:param name="schema"/>
    <xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>
  </xsl:template>
  
  
	<!-- ===================================================================== -->
	<!-- these elements should be boxed -->
	<!-- ===================================================================== -->
	<xsl:template mode="iso19139-2"
		match="gmi:MI_LegalConstraints|gmi:MI_SecurityConstraints|gmi:MI_SecurityConstraints">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="complexElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="$edit"/>
		</xsl:apply-templates>
	</xsl:template>


	<!-- Extra tabs for ISO Profil for France -->
  <xsl:template mode="extraTab" match="/">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

    <!-- MI tabs -->
		<xsl:if test="/root/gui/config/metadata-tab/gmi">
		  <xsl:call-template name="mainTab">
		    <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTab"/>
		    <xsl:with-param name="default">gmiTabDesc</xsl:with-param>
		    <xsl:with-param name="menu">
		      <item label="gmiTabDesc">gmiTabDesc</item>
		      <item label="gmiTabTech">gmiTabTech</item>
		      <item label="gmiTabQua">gmiTabQua</item>
		      <item label="gmiTabAcc">gmiTabAcc</item>
		      <item label="gmiTabMd">gmiTabMd</item>
		    </xsl:with-param>
		  </xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!--
		Redirection template for profil gmi in order to process 
		extraTabs.
	-->
	<xsl:template mode="iso19139" match="gmi:MI_Metadata|*[@gco:isoType='gmi:MI_Metadata']" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>
		
		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>
		
		<xsl:choose>
			
			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139Metadata">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- contentInfo tab -->
			<xsl:when test="$currTab='contentInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- extensionInfo tab -->
			<xsl:when test="$currTab='extensionInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- ISOMinimum tab -->
			<xsl:when test="$currTab='ISOMinimum'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="false()"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- ISOCore tab -->
			<xsl:when test="$currTab='ISOCore'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="true()"/>
				</xsl:call-template>
    
        <!-- MI elements are added -->
        <xsl:call-template name="displayGMIExtraElement">
         <xsl:with-param name="schema" select="$schema" />
         <xsl:with-param name="edit" select="$edit" />
         <xsl:with-param name="dataset" select="$dataset" />
        </xsl:call-template>
			</xsl:when>
			
			<!-- ISOAll tab -->
			<xsl:when test="$currTab='ISOAll'">
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
    
       <!-- GMI elements are added -->
       <xsl:call-template name="displayGMIExtraElement">
        <xsl:with-param name="schema" select="$schema" />
        <xsl:with-param name="edit" select="$edit" />
        <xsl:with-param name="dataset" select="$dataset" />
       </xsl:call-template>
			</xsl:when>
			
			<!-- INSPIRE tab -->
			<xsl:when test="$currTab='inspire'">
				<xsl:call-template name="inspiretabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- gmi tab -->
			<xsl:when test="$currTab='gmiTabDesc'">
				<xsl:call-template name="gmiTabDesc">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$currTab='gmiTabTech'">
				<xsl:call-template name="gmiTabTech">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$currTab='gmiTabQua'">
				<xsl:call-template name="gmiTabQua">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$currTab='gmiTabAcc'">
				<xsl:call-template name="gmiTabAcc">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$currTab='gmiTabMd'">
				<xsl:call-template name="gmiTabMd">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- default -->
			<xsl:otherwise>
				<xsl:call-template name="iso19139Simple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="flat"   select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="gmiTabDesc">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>
		
		<xsl:call-template name="complexElementGuiWrapper">
		  <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTabDesc"/>
			<xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139-2/strings/gmiTabDesc)"/>
			<xsl:with-param name="content">
		
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='title']|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:alternateTitle|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='alternateTitle']|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:edition|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='edition']|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date|
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='date']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="complexElement" select="
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:identifier
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='identifier']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:abstract|
					gmd:identificationInfo/*/geonet:child[string(@name)='abstract']|
					gmd:identificationInfo/*/gmd:purpose|
					gmd:identificationInfo/*/geonet:child[string(@name)='purpose']|
					gmd:identificationInfo/*/gmd:supplementalInformation|
					gmd:identificationInfo/*/geonet:child[string(@name)='supplementalInformation']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:topicCategory|
					gmd:identificationInfo/*/geonet:child[string(@name)='topicCategory']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/srv:serviceType|
					gmd:identificationInfo/*/geonet:child[string(@name)='serviceType']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/srv:serviceTypeVersion|
					gmd:identificationInfo/*/geonet:child[string(@name)='serviceTypeVersion']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/srv:couplingType|
					gmd:identificationInfo/*/geonet:child[string(@name)='couplingType']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				
				<!-- FIXME : take care of operatesOn adding action -->
				<xsl:apply-templates mode="complexElement" select="gmd:identificationInfo/*/srv:operatesOn[1]">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
					<xsl:with-param name="content">
						<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/srv:operatesOn|
							gmd:identificationInfo/*/geonet:child[string(@name)='operatesOn']">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="edit"   select="$edit"/>
							<xsl:with-param name="force"   select="true()"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:apply-templates>
				
				
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:descriptiveKeywords
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				<xsl:if test="not(gmd:identificationInfo/*/gmd:descriptiveKeywords)">
					<xsl:apply-templates mode="elementEP" select="
						gmd:identificationInfo/*/geonet:child[string(@name)='descriptiveKeywords']
						">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="force"   select="true()"/>
					</xsl:apply-templates>
				</xsl:if>
				
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:pointOfContact
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
				<xsl:if test="not(gmd:identificationInfo/*/gmd:pointOfContact)">
					<xsl:apply-templates mode="elementEP" select="
						gmd:identificationInfo/*/geonet:child[string(@name)='pointOfContact']
						">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
						<xsl:with-param name="force"   select="true()"/>
					</xsl:apply-templates>
				</xsl:if>
				
				<xsl:for-each select="gmd:identificationInfo/*/gmd:extent">
					<xsl:apply-templates mode="complexElement" select=".">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="true()"/>
						<xsl:with-param name="content">
							<xsl:apply-templates mode="elementEP" select="gmd:EX_Extent/gmd:description|
								./gmd:EX_Extent/gmd:geographicElement">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
							<xsl:apply-templates mode="elementEP" select="./gmd:EX_Extent/geonet:child[string(@name)='geographicElement']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
								<xsl:with-param name="force"   select="true()"/>
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:apply-templates> 
					
					<!-- FIXME : how to force display of add/delete option -->
					<xsl:apply-templates mode="elementEP" select="gmd:EX_Extent/gmd:verticalElement|gmd:EX_Extent/gmd:temporalElement">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
		
		
	</xsl:template>
	<xsl:template name="gmiTabTech">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>
		
		<xsl:call-template name="complexElementGuiWrapper">
		  <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTabTech"/>
		  <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139-2/strings/gmiTabTech)"/>
			<xsl:with-param name="content">
						
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:status|
					gmd:identificationInfo/*/geonet:child[string(@name)='status']|
					gmd:identificationInfo/*/gmd:resourceMaintenance|
					gmd:identificationInfo/*/geonet:child[string(@name)='resourceMaintenance']|
					gmd:identificationInfo/*/gmd:spatialRepresentationType|
					gmd:identificationInfo/*/geonet:child[string(@name)='spatialRepresentationType']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:spatialRepresentationInfo|
					geonet:child[string(@name)='spatialRepresentationInfo']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:spatialResolution|
					gmd:identificationInfo/*/geonet:child[string(@name)='spatialResolution']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:referenceSystemInfo|
					geonet:child[string(@name)='referenceSystemInfo']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:relatedCitation/gmd:CI_Citation|
					gmd:identificationInfo/*/gmd:relatedCitation/geonet:child[string(@name)='CI_Citation']">		
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:language|
					geonet:child[string(@name)='language']|                            
					gmd:characterSet|
					geonet:child[string(@name)='characterSet']                           
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>
	<xsl:template name="gmiTabQua">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>
		
		<xsl:call-template name="complexElementGuiWrapper">
		  <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTabQua"/>
		  <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139-2/strings/gmiTabQua)"/>
			<xsl:with-param name="content">
				
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:dataQualityInfo|
					geonet:child[string(@name)='dataQualityInfo']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	<xsl:template name="gmiTabAcc">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>
		
		<xsl:call-template name="complexElementGuiWrapper">
		  <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTabAcc"/>
		  <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139-2/strings/gmiTabAcc)"/>
			<xsl:with-param name="content">
						
				<xsl:apply-templates mode="elementEP" select="
					gmd:distributionInfo|
					geonet:child[string(@name)='distributionInfo']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:identificationInfo/*/gmd:resourceConstraints">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/geonet:child[string(@name)='resourceConstraints']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="force"   select="true()"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	<xsl:template name="gmiTabMd">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="core"/>
		
		<xsl:call-template name="complexElementGuiWrapper">
		  <xsl:with-param name="title" select="/root/gui/schemas/iso19139-2/strings/gmiTabMd"/>
		  <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139-2/strings/gmiTabMd)"/>
			<xsl:with-param name="content">
						
				<xsl:apply-templates mode="elementEP" select="
					gmd:fileIdentifier|
					gmd:language|
					geonet:child[string(@name)='language']|
					gmd:characterSet|
					geonet:child[string(@name)='characterSet']|
					gmd:hierarchyLevel|
					geonet:child[string(@name)='hierarchyLevel']|
					gmd:hierarchyLevelName|
					geonet:child[string(@name)='hierarchyLevelName']|
					gmd:parentIdentifier|
					geonet:child[string(@name)='parentIdentifier']|
					gmd:contact|
					geonet:child[string(@name)='contact']|
					gmd:dateStamp|
					geonet:child[string(@name)='dateStamp']|
					gmd:metadataStandardName|
					geonet:child[string(@name)='metadataStandardName']|
					gmd:metadataStandardVersion|
					geonet:child[string(@name)='metadataStandardVersion']
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates mode="elementEP" select="
					gmd:metadataConstraints
					">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
 
 
 <!-- =================================================================== -->
 <!-- === Displays EURAC extra elements -->
 <!-- =================================================================== -->
 <xsl:template name="displayGMIExtraElement">
  <xsl:param name="schema" />
  <xsl:param name="edit" />
  <!-- All of these specified elements are added as an own tab at the end -->
  <xsl:apply-templates mode="elementEP"
   select="gmi:acquisitionInformation|geonet:child[string(@name)='acquisitionInformation']">
   <xsl:with-param name="schema" select="$schema" />
   <xsl:with-param name="edit" select="$edit" />
  </xsl:apply-templates>
 </xsl:template>
 
</xsl:stylesheet>
