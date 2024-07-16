@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Authorization - Price'
define view entity ZI_PR_AUTH_PRICE
  as select from zpr_auth_price
{
      @EndUserText.label : 'PR Auth'
  key price_auth         as PriceAuth,
      @EndUserText.label : 'Material'
  key material           as Material,
      @EndUserText.label : 'Condition Type'
  key cond_type          as CondType,
      @EndUserText.label : 'New'
      price_new          as PriceNew,
      @EndUserText.label : 'Curr'
      price_curr         as PriceCurr,
      @EndUserText.label : 'Currency'
      currency           as Currency,
      @EndUserText.label : 'Dealer Margin'
      dealer_margin      as DealerMargin,
      @EndUserText.label : 'PCI Margin'
      pci_margin      as PCIMargin,
      @EndUserText.label : 'Scale 1'
      scale1             as Scale1,
      @EndUserText.label : 'Price'
      s1price            as Scale1Price,
      @EndUserText.label : 'Scale 2'
      scale2             as Scale2,
      @EndUserText.label : 'Price'
      s2price            as Scale2Price,
      @EndUserText.label : 'Scale 3'
      scale3             as Scale3,
      @EndUserText.label : 'Price'
      s3price            as Scale3Price,
      @EndUserText.label : 'Scale 4'
      scale4             as Scale4,
      @EndUserText.label : 'Price'
      s4price            as Scale4Price,
      @EndUserText.label : 'Scale 5'
      scale5             as Scale5,
      @EndUserText.label : 'Price'
      s5price            as Scale5Price,
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
