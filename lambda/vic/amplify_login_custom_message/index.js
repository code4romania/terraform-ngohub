"use strict";

const { getForgotPasswordEmailTemplate, getForgotPasswordEmailTitle, getInviteUserEmailTemplate, getInviteUserEmailTitle } = require('./email_template_gen');

exports.handler = async (event, context, callback) => {

  const contactEmail = process.env.email_contact;
  const emailAssetsUrl = process.env.email_assets_url;


  if (event.triggerSource === 'CustomMessage_SignUp') {
    event.response = {
      emailSubject: getInviteUserEmailTitle(),
      emailMessage: getInviteUserEmailTemplate(event.request.usernameParameter, event.request.codeParameter, contactEmail, emailAssetsUrl),
    };
  }

  if (event.triggerSource === "CustomMessage_ForgotPassword") {
    event.response = {
      emailSubject: getForgotPasswordEmailTitle(),
      emailMessage: getForgotPasswordEmailTemplate(event.request.codeParameter, contactEmail, emailAssetsUrl)
    };
  }

  callback(null, event);
  return event;
};
