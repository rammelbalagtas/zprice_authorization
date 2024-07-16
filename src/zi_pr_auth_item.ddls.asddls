@EndUserText.label: 'PR Authorization - Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_PR_AUTH_ITEM
  as select from zpr_auth_item
{
      @EndUserText.label : 'PR Auth'
  key price_auth         as PriceAuth,
      @EndUserText.label : 'Material'
  key material           as Material,
      sequence           as Sequence,
      @EndUserText.label : 'Reject'
      reject             as Reject,
      @EndUserText.label : 'GM Budget'
      gm_budget          as GmBudget,
      @EndUserText.label : 'GM Actual'
      gm_actual          as GmActual,
      @EndUserText.label : 'eStore Freeze'
      estore_freeze      as EstoreFreeze,
      @EndUserText.label : 'PP Qty'
      price_prot         as PriceProt,
      @EndUserText.label : 'PP Impact'
      pp_impact          as PpImpact,
      @EndUserText.label : 'OH & I Qty'
      onhand_inc         as OnhandInc,
      @EndUserText.label : 'OH & I Impact'
      onhand_inc_impact  as OnhandIncImpact,
      @EndUserText.label : 'Map'
      map                as Map,
      status             as Status,
      @EndUserText.label : 'Unit'
      unit               as Unit,
      @EndUserText.label : 'Currency'
      currency           as Currency,
      @Semantics.user.createdBy: true
      localcreatedby     as Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat     as Localcreatedat,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat
}
