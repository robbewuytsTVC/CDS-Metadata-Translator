@AbapCatalog.sqlViewName: 'ZCDSTRANSL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS metadata translations'
//TODO get master language in TADIR + create helper CDS in order to define the inner join. Some views are not created in EN
define view Z_CDS_META_TRANSLATIONS
  as select from ddlx_rt_data
    inner join   ddlx_rt_data_t as t_en on  t_en.ddlxname   = ddlx_rt_data.ddlxname
                                        and t_en.element    = ddlx_rt_data.element
                                        and t_en.name       = ddlx_rt_data.name
                                        and t_en.ddlanguage = 'E'
  association        to parent Z_CDS_META_TRANSLATIONS_ROOT as _parent on  $projection.Ddlxname = _parent.Ddlxname
  //  association [1..1] to ddlx_rt_data_t                      as t_en    on  t_en.ddlxname   = $projection.Ddlxname
  //                                                                       and t_en.element    = $projection.Element
  //                                                                       and t_en.name       = $projection.Name
  //                                                                       and t_en.ddlanguage = 'D'
  association [1..1] to ddlx_rt_data_t                      as t_de    on  t_de.ddlxname   = $projection.Ddlxname
                                                                       and t_de.element    = $projection.Element
                                                                       and t_de.name       = $projection.Name
                                                                       and t_de.ddlanguage = 'D'
  association [1..1] to ddlx_rt_data_t                      as t_nl    on  t_nl.ddlxname   = $projection.Ddlxname
                                                                       and t_nl.element    = $projection.Element
                                                                       and t_nl.name       = $projection.Name
                                                                       and t_nl.ddlanguage = 'N'
  association [1..1] to ddlx_rt_data_t                      as t_fr    on  t_fr.ddlxname   = $projection.Ddlxname
                                                                       and t_fr.element    = $projection.Element
                                                                       and t_fr.name       = $projection.Name
                                                                       and t_fr.ddlanguage = 'F'
{
  key ddlx_rt_data.ddlxname as Ddlxname,
  key ddlx_rt_data.element  as Element,
  key ddlx_rt_data.name     as Name,


      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ZCL_PM_CDS_TRANSLATION_FACT'
      //      cast( ''  as lxetextkey)               as TextKey,
      element_type          as ElementType,
      value                 as Value,
      t_en.text             as EnglishTranslation,
      cast( '' as flag )    as EnglishTranslationChanged,
      t_nl.text             as DutchTranslation,
      cast( '' as flag )    as DutchTranslationChanged,
      t_fr.text             as FrenchTranslation,
      cast( '' as flag )    as FrenchTranslationChanged,
      t_de.text             as GermanTranslation,
      cast( '' as flag )    as GermanTranslationChanged,
      _parent
}
