@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds Dealer Rate Master'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_DEALERRT_TAB
  as select from zdealer_ratemst1
  //composition of target_data_source_name as _association_name
{
  key drdealercode          as Drdealercode,
  key drprdcode             as Drprdcode,
  key  comp_code             as CompanyCode,
   drprdrate             as Drprdrate,
   drprdrplratio         as Drprdrplratio,
      drusername            as Drusername,
      drprdmop              as Drprdmop,
      drprdsdr              as Drprdsdr,
      drprdwsb              as Drprdwsb,
      drprdrdc              as Drprdrdc,
      drprdwsb1             as Drprdwsb1,
      drprdwsb2             as Drprdwsb2,
      drprdwsb3             as Drprdwsb3,
      drupdt                as Drupdt,
      drid                  as Drid,
      drprdrdc1             as Drprdrdc1,
      drprdrplratio1        as Drprdrplratio1,
      drrateapcbfrom        as Drrateapcbfrom,
      drstatus              as Drstatus,
      docdealerloc          as Docdealerloc,
      drdocno               as Drdocno,
      drdocdate             as Drdocdate,
      drreplrate1           as Drreplrate1,
      drremarks             as Drremarks,
      dronbillos            as Dronbillos,
      droffbillos           as Droffbillos,
      droffbillcrdo         as Droffbillcrdo,
      drtgtqty              as Drtgtqty,
      drprdmrp              as Drprdmrp,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
      //_association_name // Make association public
}
