function zrecast_hook.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(NLP) TYPE  ZRECAST_NLP
*"  EXPORTING
*"     REFERENCE(REPLIES) TYPE  ZRECAST_MESSAGE_TAB
*"  CHANGING
*"     REFERENCE(_ICF_DATA) TYPE  ZICF_HANDLER_DATA
*"     REFERENCE(CONVERSATION) TYPE  ZRECAST_CONV
*"----------------------------------------------------------------------

  data m_text type zrecast_message.
  data m_button type zrecast_button.

  field-symbols <card> type zrecast_card.
  field-symbols <ct> type string.

  data conv_changed type xfeld.

  if conversation-memory-person-fullname is initial.
    m_text-type = 'text'.
    create data m_text-content type string.
    assign m_text-content->* to <ct>.
    <ct> = 'Saludos desde ABAP, pero dime algo que así no hay nada que hacer.'.
    append m_text to replies.
    clear m_text.

*

  else.


    if conversation-memory-email-raw is not initial.


      if    conversation-memory-l_application_name-raw is not initial.
*        and conversation-memory-l_entity-raw is not initial.

        data datos_permiso type zfdt_7002qkmns8bdpuoue9nfj4s3o.
        data datos_usuario type zfdt_7002qkmns8bdpuoue9nfj54qs.
        data datos_validador type zfdt_7002qkmns8bdpuoue9nfj5hdw.

        datos_permiso-application_name = conversation-memory-l_application_name-raw.
        datos_usuario-bu_dept = conversation-memory-l_budpt-raw.
        datos_usuario-entity = conversation-memory-l_entity-raw.

        call function 'Z_LOB_RUNVAL'
          exporting
            datos_permiso     = datos_permiso
            datos_usuario     = datos_usuario
          importing
            e_datos_validador = datos_validador
*       EXCEPTIONS
*           CX_FDT            = 1
*           CX_FDT_NO_RESULT  = 2
*           CX_FDT_ARITHMETIC_ERROR       = 3
*           CX_FDT_PROCESSING = 4
*           OTHERS            = 5
          .
        if sy-subrc <> 0.
* Implement suitable error handling here
        endif.

        m_text-type = 'card'.
        create data m_text-content type zrecast_card.
        assign m_text-content->* to <card>.

        m_button-title = datos_validador-v_phone_number.
        concatenate 'tel:' datos_validador-v_phone_number into m_button-value.
        m_button-type = 'web_url'.
*Recast Button Types:
*postback: the basic type, once the button is tapped, the value is sent as a normal incoming message
*web_url: depending on the channel, once this button is tapped, the URL in the value field is loaded
*phone_number: depending on the channel, once this button is tapped, the phone number in the value field will be called
**************

        append m_button to <card>-buttons.

        clear m_button.
        m_button-title = datos_validador-v_email.
        concatenate 'mailto:' datos_validador-v_email into m_button-value.
        m_button-type = 'web_url'.
        append m_button to <card>-buttons.

        <card>-title = datos_validador-validator.
        <card>-subtitle = 'Validador principal'.
        <card>-image_url = datos_validador-v_image_url.


        append m_text to replies.




        m_text-type = 'text'.
        create data m_text-content type string.
        assign m_text-content->* to <ct>.
        concatenate 'ABAP dice que tu validador es' datos_validador-validator into <ct> separated by space.
        append m_text to replies.
        clear m_text.




      else.



        if conversation-memory-email-domain eq 'logista.net'
           or
           conversation-memory-email-domain eq 'sabadell.net'
           or
           conversation-memory-email-domain eq 'correos.net'
           or
           conversation-memory-email-domain eq 'penhaligons.net'
           or
           conversation-memory-email-domain eq 'puig.net'
           or
           conversation-memory-email-domain eq 'acciona.net'
           or
           conversation-memory-email-domain eq 'mapfre.net'.

*          memory = conversation-memory.

          conversation-memory-l_entity-raw = 'GROUP'.
          conversation-memory-l_entity-value = conversation-memory-l_entity-raw.
          conversation-memory-l_entity-confidence = '0.99'.

          conversation-memory-l_budpt-raw = 'IBERIA_FINANCE'.
          conversation-memory-l_budpt-value = conversation-memory-l_budpt-raw.
          conversation-memory-l_budpt-confidence = '0.99'.

          conv_changed = 'X'.

          m_text-type = 'text'.
          create data m_text-content type string.
          assign m_text-content->* to <ct>.
          concatenate 'Según el servidor LDAP, tu entidad es ' conversation-memory-l_entity-raw
                       'y tu departamento es' conversation-memory-l_budpt-raw
                      into <ct> separated by space.
          append m_text to replies.
          clear m_text.

        elseif conversation-memory-email-domain eq 'preventas.sap'.

          m_text-type = 'text'.
          create data m_text-content type string.
          assign m_text-content->* to <ct>.
          concatenate 'Hola ' conversation-memory-person-raw
                       '. Ya veo que eres de Preventas. Suerte con la demo!!!'
                       'Vamos a desayunar.'
                      into <ct> separated by space.
          append m_text to replies.
          clear m_text.

        endif.


      endif.



    endif.

  endif.


  if conv_changed is initial.

    append 'CONVERSATION' to _icf_data-delete_params.

  endif.

  if replies is initial.

    append 'REPLIES' to _icf_data-delete_params.

  else.

    append 'replies' to _icf_data-camelcase_names.
    append 'REPLIES' to _icf_data-camelcase_names.

  endif.



endfunction.
