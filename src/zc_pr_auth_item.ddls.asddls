@EndUserText.label: 'Items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_PR_AUTH_ITEM
  as projection on ZR_PR_AUTH_ITEM
{
  key PriceAuth,
  key Material,
      Sequence,
      Reject,
      GmBudget,
      GmActual,
      EstoreFreeze,
      PriceProt,
      PpImpact,
      OnhandInc,
      OnhandIncImpact,
      Map,
      Status,
      Unit,
      Currency,
      Notes,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Header   : redirected to parent ZC_PR_AUTH_HEAD,
      _Price    : redirected to composition child ZC_PR_AUTH_PRICE,
      _Customer : redirected to composition child ZC_PR_AUTH_CUST
}
