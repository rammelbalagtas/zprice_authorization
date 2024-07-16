@EndUserText.label: 'Price'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_PR_AUTH_PRICE
  as projection on ZR_PR_AUTH_PRICE
{
  key PriceAuth,
  key Material,
  key CondType,
      PriceNew,
      PriceCurr,
      Currency,
      DealerMargin,
      PCIMargin,
      Scale1,
      Scale1Price,
      Scale2,
      Scale2Price,
      Scale3,
      Scale3Price,
      Scale4,
      Scale4Price,
      Scale5,
      Scale5Price,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      /* Associations */
      _Header : redirected to ZC_PR_AUTH_HEAD,
      _Item : redirected to parent ZC_PR_AUTH_ITEM
}
