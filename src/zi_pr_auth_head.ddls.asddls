@EndUserText.label: 'PR Authorization - Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_PR_AUTH_HEAD
  as select from zpr_auth_head
{
      @EndUserText.label : 'PR Auth'
  key price_auth         as PriceAuth,
      @EndUserText.label : 'High Priority'
      high_priority      as HighPriority,
      @EndUserText.label : 'Description'
      description        as Description,
      @EndUserText.label : 'Valid From'
      valid_from         as ValidFrom,
      @EndUserText.label : 'Valid To'
      valid_to           as ValidTo,
      @EndUserText.label : 'Status'
      status             as Status,
      @EndUserText.label : 'Submitted To'
      submitted_to       as SubmittedTo,
      @EndUserText.label : 'Notify'
      notify             as Notify,
      @EndUserText.label : 'Last imported file'
      attachment_u       as AttachmentUpload,
      mimetype_u         as MimeTypeUpload,
      filename_u         as FilenameUpload,
      @EndUserText.label : 'Last exported file'
      attachment_d       as AttachmentDownload,
      mimetype_d         as MimeTypeDownload,
      filename_d         as FilenameDownload,
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
