@EndUserText.label: 'Customer'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_PR_AUTH_CUST
  as projection on ZR_PR_AUTH_CUST
{
  key PriceAuth,
  key Material,
  key CondType,
  key Customer,
      PriceNew,
      Currency,
      DealerMargin,
      PCIMargin,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      /* Associations */
      _Header : redirected to ZC_PR_AUTH_HEAD,
      _Item   : redirected to parent ZC_PR_AUTH_ITEM
}
