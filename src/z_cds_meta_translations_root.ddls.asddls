@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Root entity for CDS Translations'
define root view entity Z_CDS_META_TRANSLATIONS_ROOT as select from Z_CDS_METADATA_EXTENSIONS
 composition [0..*] of Z_CDS_META_TRANSLATIONS as _Translations {
    key Ddlxname,
    ChangedBy,
    ChangedOn,
    ChangedAt,
    Uuid,
    AbapLanguageVersion,
    MasterLanguage,
    /* Associations */
    _Translations
}
