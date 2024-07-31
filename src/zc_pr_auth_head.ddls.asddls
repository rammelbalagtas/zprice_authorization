@EndUserText.label: 'Price Authorization'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.query.implementedBy: 'ABAP:ZCL_PRAUTH_READ'
define root view entity ZC_PR_AUTH_HEAD
  provider contract transactional_query
  as projection on ZR_PR_AUTH_HEAD
{
  key PriceAuth,
      HighPriority,
      Description,
      ValidFrom,
      ValidTo,
      Status,
      StatusText,
      SubmittedTo,
      Notify,
      @Semantics.largeObject: {
        acceptableMimeTypes: [ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
        cacheControl.maxAge: #MEDIUM,
        contentDispositionPreference: #ATTACHMENT , // #ATTACHMENT - download as file
                                                    // #INLINE - open in new window
        fileName: 'FilenameUpload',
        mimeType: 'MimeTypeUpload'
      }
      AttachmentUpload,
      @Semantics.mimeType: true
      MimeTypeUpload,
      FilenameUpload,
      @Semantics.largeObject: {
        acceptableMimeTypes: [ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
        cacheControl.maxAge: #MEDIUM,
        contentDispositionPreference: #INLINE , // #ATTACHMENT - download as file
                                                    // #INLINE - open in new window
        fileName: 'FilenameDownload',
        mimeType: 'MimeTypeDownload'
      }
      AttachmentDownload,
      @Semantics.mimeType: true
      MimeTypeDownload,
      FilenameDownload,
      Localcreatedby,
      Localcreatedat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      /* Associations */
      _Item: redirected to composition child ZC_PR_AUTH_ITEM
}
