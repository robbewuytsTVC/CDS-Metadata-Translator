@AbapCatalog.sqlViewName: 'ZCDSMETADATAEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS metadata extensions'
define view Z_CDS_METADATA_EXTENSIONS as select from ddlxsrc 
association [1..1] to tadir on pgmid  = 'R3TR' and object = 'DDLX' and ddlxsrc.ddlxname = tadir.obj_name
//association [0..*] to slx_log
association [0..*] to Z_CDS_META_TRANSLATIONS as _LabelTranslations on _LabelTranslations.Ddlxname = ddlxsrc.ddlxname {
    key ddlxname as Ddlxname,
    changed_by as ChangedBy,
    changed_on as ChangedOn,
    changed_at as ChangedAt,
    uuid as Uuid,
    abap_language_version as AbapLanguageVersion,
    tadir.masterlang as MasterLanguage,
    
//    concat( 'DDLX', concat( right (ddlxname, 40), '06'), '#') as ObjectName,
//    concat('DDLX', ddlxname) as Objectname,
    _LabelTranslations
}
