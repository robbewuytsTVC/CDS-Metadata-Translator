@AbapCatalog.sqlViewName: 'Z_TR_REQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Transport Request'
define view Z_TRANSPORT_REQUEST as select from e070 
association [1..1] to e07t on e070.trkorr = e07t.trkorr
{
    key trkorr as Trkorr,
    trfunction as Trfunction,
    trstatus as Trstatus,
    tarsystem as Tarsystem,
    korrdev as Korrdev,
    as4user as As4user,
    as4date as As4date,
    as4time as As4time,
    strkorr as Strkorr,
    e07t.langu as Langu,
    e07t.as4text as As4text
}
