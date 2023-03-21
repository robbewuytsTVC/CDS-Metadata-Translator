@AbapCatalog.sqlViewName: 'Z_MYMODWBTRREQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'My modifiable workbench transport requests'
define view Z_MY_MODIF_WB_TR_REQUESTS as select from Z_TRANSPORT_REQUEST {
    key Trkorr,
//    Trfunction,
//    Trstatus,
    Tarsystem,
    Korrdev,
    As4user,
    As4date,
    As4time,
    Strkorr,
    Langu,
    As4text
} where As4user = $session.user and ( Trstatus = 'D' or Trstatus = 'L' ) and Trfunction = 'K'
