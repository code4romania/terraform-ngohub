const FORGOT_PASSWORD_CONTENT = (codeParameter, contactEmail, emailAssetsUrl) => `
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<style>
  @font-face {
    font-family: "Titillium Web";
    font-style: normal;
    font-weight: 400;
    src: url(https://fonts.gstatic.com/s/titilliumweb/v15/NaPecZTIAOhVxoMyOr9n_E7fdMPmDaZRbrw.woff2) format("woff2");
    unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6,
      U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193,
      U+2212, U+2215, U+FEFF, U+FFFD;
  }
</style>
</head>

<body style="
  font-family: 'Titillium Web', sans-serif !important;
  font-size: 16px !important;
  margin: 0 !important;
">
<div style="
    background-color: #ffffff;
    width: 100%;
    max-width: 700px;
    margin: 0 auto;
  ">
  <div>
    <img src="${emailAssetsUrl}/email/header.png" style="width: 100%" />
  </div>
  <div id="content" style="padding: 1rem 5rem 3rem 1.5rem">
    <h1 style="margin-bottom: 1.5rem; color: #000000 !important">
      Codul tău de verificare
    </h1>
    <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
      Bună,<br /><br />
      Codul tău de verificare este
      <strong>${codeParameter}</strong>.
    </p>
    <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
      Dacă întâmpini vreo problemă ne poți transmite un email pe adresa
      <a style="
          text-decoration: none;
          color: #1a15ea;
          font-size: 1rem;
          line-height: 1.5rem;
        " href="mailto:${contactEmail}">${contactEmail}</a>.
    </p>
  </div>
  <div style="
      background-color: #000000;
      color: #ffffff !important;
      padding: 1.5rem 5rem;
    ">
    <table style="
        width: 80%;
        border: none;
        margin-left: auto;
        margin-right: auto;
        padding-bottom: 1rem;
      ">
      <tr>
        <td>
          <p style="color: #ffffff !important; font-size: 0.75rem">
            Soluție proiectată, dezvoltată și administrată pro-bono de
          </p>
        </td>
        <td>
          <img class="logo" style="width:140px" src="${emailAssetsUrl}/email/logo.png" />
        </td>
      </tr>
    </table>

    <div style="width: 100%; height: 1px; background: #ffffff"></div>

    <p style="
        text-align: center;
        width: 100%;
        color: #ffffff !important;
        font-size: 0.75rem;
        margin-top: 1.5rem;
      ">
      Dacă vrei să iei legătura cu noi o poți face pe e-mail la adresa:
      <a style="color: #ffffff !important; font-size: 0.75rem" href="mailto:${contactEmail}">${contactEmail}</a>
    </p>

    <table style="
        width: 50%;
        border: none;
        margin-left: auto;
        margin-right: auto;
        padding-top: 1rem;
      ">
      <tr>
        <td>
          <a style="text-decoration: none; color: #1a15ea" href="https://www.facebook.com/code4romania/"
            target="_blank">
            <img style="margin: 0 1rem" src="${emailAssetsUrl}/email/social/facebook.png" /></a>
        </td>
        <td>
          <a style="text-decoration: none; color: #1a15ea" href="https://www.instagram.com/code4romania"
            target="_blank">
            <img style="margin: 0 1rem" src="${emailAssetsUrl}/email/social/instagram.png" /></a>
        </td>
        <td>
          <a style="text-decoration: none; color: #1a15ea" href="https://www.youtube.com/@codeforromania5856" target="_blank">
            <img style="margin: 0 1rem" src="${emailAssetsUrl}/email/social/youtube.png" /></a>
        </td>
        <td>
          <a style="text-decoration: none; color: #1a15ea" href="https://github.com/code4romania/" target="_blank">
            <img style="margin: 0 1rem" src="${emailAssetsUrl}/email/social/github.png" /></a>
        </td>
      </tr>
    </table>
  </div>
</div>
</body>
`

const USER_INVITE_CONTENT = (username, tempPassword, inviteLink, contactEmail, emailAssetsUrl) => `
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <style>
        @font-face {
            font-family: 'Titillium Web';
            font-style: normal;
            font-weight: 400;
            src: url(https://fonts.gstatic.com/s/titilliumweb/v15/NaPecZTIAOhVxoMyOr9n_E7fdMPmDaZRbrw.woff2) format('woff2');
            unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6,
                U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193,
                U+2212, U+2215, U+FEFF, U+FFFD;
        }
    </style>
    </head>

    <body style="
      font-family: 'Titillium Web', sans-serif !important;
      font-size: 16px !important;
      margin: 0 !important;
    ">
    <div style="
        background-color: #ffffff;
        width: 100%;
        max-width: 700px;
        margin: 0 auto;
      ">
        <div>
            <img src="${emailAssetsUrl}/email/header.png" style="width: 100%" />
        </div>
        <div style="padding: 1rem 5rem 3rem 5rem">
            <h1 style="margin-bottom: 1.5rem; color: #000000 !important">
                Parola ta temporară
            </h1>
            <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
                Bună,
            </p>
            <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
                Contul tău de NGO Hub a fost creat cu success.
                Ți-am pregătit o parolă temporară cu care îți poți activa contul pentru a-ți crea apoi parola ta unică.
            </p>
            <p style="font-size: 1rem; line-height: 0.5rem; color: #000000 !important">Username:</p>
            <p style="font-size: 1rem; font-weight: bold; line-height: 0.5rem; text-indent: 1.5rem; color: #000000 !important">${username}</p>
            <p style="font-size: 1rem; line-height: 0.5rem; color: #000000 !important">Parola temporară:</p>
            <p style="font-size: 1rem; font-weight: bold; line-height: 0.5rem; text-indent: 1.5rem; color: #000000 !important">${tempPassword}</p>
            <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
                Parola temporară este generată automat, și conține caractere diverse.
                Ai grijă când o copiezi,
                să nu adaugi un spațiu în plus sau să selectezi un caracter în minus.
            </p>
            <a href="${inviteLink}"
              target="_blank"
              style="
                min-width: fit-content;
                padding: 10px 17px;
                color: #000000;
                background-color: #fff649;
                width: 8rem;
                height: 2.5rem;
                border-radius: 6px;
                border-width: 0;
                cursor: pointer;
            ">
              Accesează NGO Hub
            </a>
            <p style="
                font-size: 1rem;
                line-height: 1.5rem;
                color: #000000 !important;
                margin-top: 1rem;
              ">
                Sau accesează link-ul de mai jos:
                <a style="
                  text-decoration: none;
                  color: #1a15ea;
                  font-size: 1rem;
                  line-height: 1.5rem;
                "
                href="${inviteLink}">${inviteLink}</a>
            </p>
            <p style="font-size: 1rem; line-height: 1.5rem; color: #000000 !important">
                După ce îți setezi parola ta unică, vei putea accesa toate soluțiile digitale disponibile în NGO Hub, folosind același cont unic.
                <br>
                Dacă întâmpini vreo problemă, ne poți scrie pe adresa
                <a style="
                  text-decoration: none;
                  color: #1a15ea;
                  font-size: 1rem;
                  line-height: 1.5rem;
                " href="mailto:${contactEmail}">${contactEmail}</a>.
            </p>

        </div>
        <div style="
        background-color: #000000;
        color: #ffffff !important;
        padding: 1.5rem 1.5rem;
        ">
          <table style="width: 80%; border: none; margin-left: auto; margin-right: auto; padding-bottom: 1rem">
              <tr>
                  <td>
                      <p style="color: #ffffff !important; font-size: 0.75rem">
                          Soluție proiectată, dezvoltată și administrată pro-bono de
                      </p>
                  </td>
                  <td>
                      <img class="logo" style="width:140px"
                          src="${emailAssetsUrl}/email/logo.png" />
                  </td>
              </tr>
          </table>

          <div style="width: 100%; height: 1px; background: #ffffff"></div>

          <p style="
          text-align: center;
          width: 100%;
          color: #ffffff !important;
          font-size: 0.75rem;
          margin-top: 1.5rem
        ">
              Dacă vrei să iei legătura cu noi o poți face pe e-mail la adresa:
              <a style="color: #ffffff !important; font-size: 0.75rem;" href="mailto:${contactEmail}">${contactEmail}</a>
          </p>

          <table style="width: 50%; border: none; margin-left: auto; margin-right: auto; padding-top: 1rem">
              <tr>
                  <td>
                      <a style="text-decoration: none; color: #1a15ea" href="https://www.facebook.com/code4romania/"
                          target="_blank">
                          <img style="margin: 0 1rem" alt="Facebook"
                              src="${emailAssetsUrl}/email/social/facebook.png" /></a>
                  </td>
                  <td>
                      <a style="text-decoration: none; color: #1a15ea" href="https://www.instagram.com/code4romania"
                          target="_blank">
                          <img style="margin: 0 1rem" alt="Instagram"
                              src="${emailAssetsUrl}/email/social/instagram.png" /></a>
                  </td>
                  <td>
                      <a style="text-decoration: none; color: #1a15ea" href="https://www.youtube.com/@codeforromania5856" target="_blank">
                          <img style="margin: 0 1rem" alt="YouTube"
                              src="${emailAssetsUrl}/email/social/youtube.png" /></a>
                  </td>
                  <td>
                      <a style="text-decoration: none; color: #1a15ea" href="https://github.com/code4romania/"
                          target="_blank">
                          <img style="margin: 0 1rem" alt="GitHub"
                              src="${emailAssetsUrl}/email/social/github.png" /></a>
                  </td>
              </tr>
          </table>
        </div>
        </div>
        </body>
`

module.exports = {
  getForgotPasswordEmailTemplate: FORGOT_PASSWORD_CONTENT,
  getForgotPasswordEmailTitle: () => 'Codul tău de verificare',
  getInviteUserEmailTemplate: USER_INVITE_CONTENT,
  getInviteUserEmailTitle: (username) => 'Bun venit in NGO Hub!'
}
