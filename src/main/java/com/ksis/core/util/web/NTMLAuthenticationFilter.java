//package com.ksis.core.util.web;
//
//
//import java.io.IOException;
//
//import java.security.Principal;
//
//import java.util.Enumeration;
//import java.util.HashMap;
//import java.util.Map;
//import java.util.Map.Entry;
//
//import javax.security.auth.Subject;
//
//import javax.servlet.Filter;
//import javax.servlet.FilterChain;
//import javax.servlet.FilterConfig;
//import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
//import javax.servlet.ServletResponse;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//
////import waffle.servlet.AutoDisposableWindowsPrincipal;
////import waffle.servlet.NegotiateRequestWrapper;
////import waffle.servlet.WindowsPrincipal;
////import waffle.servlet.spi.SecurityFilterProvider;
////import waffle.servlet.spi.SecurityFilterProviderCollection;
////
////import waffle.util.AuthorizationHeader;
////
////import waffle.windows.auth.IWindowsAuthProvider;
////import waffle.windows.auth.IWindowsIdentity;
////import waffle.windows.auth.IWindowsImpersonationContext;
////import waffle.windows.auth.PrincipalFormat;
////import waffle.windows.auth.impl.WindowsAuthProviderImpl;
//
///**
// * A Negotiate (NTLM/Kerberos) Security Filter
// * @author dblock[at]dblock[dot]org
// */
//public class NTMLAuthenticationFilter implements Filter {
//
//    private Log _log = LogFactory.getLog(NTMLAuthenticationFilter.class);
////    private PrincipalFormat _principalFormat = PrincipalFormat.fqn;
////    private PrincipalFormat _roleFormat = PrincipalFormat.fqn;
////    private SecurityFilterProviderCollection _providers = null;
////    private IWindowsAuthProvider _auth;
//    private boolean _allowGuestLogin = true;
//    private boolean _impersonate = false;
//    private static final String PRINCIPAL_SESSION_KEY =
//        NTMLAuthenticationFilter.class.getName() + ".PRINCIPAL";
//
//    public NTMLAuthenticationFilter() {
//        _log.debug("[waffle.servlet.NegotiateSecurityFilter] loaded");
//    }
//
//    public void destroy() {
//        _log.info("[waffle.servlet.NegotiateSecurityFilter] stopped");
//    }
//
//    public void doFilter(ServletRequest sreq, ServletResponse sres,
//                         FilterChain chain) throws IOException,
//                                                   ServletException {
//
//        HttpServletRequest request = (HttpServletRequest)sreq;
//        HttpServletResponse response = (HttpServletResponse)sres;
//
//        _log.info(request.getMethod() + " " + request.getRequestURI() +
//                  ", contentlength: " + request.getContentLength());
//
//        if (doFilterPrincipal(request, response, chain)) {
//            // previously authenticated user
//            return;
//        }
//
//        AuthorizationHeader authorizationHeader =
//            new AuthorizationHeader(request);
//
//        // authenticate user
//        if (!authorizationHeader.isNull()) {
//
//            // log the user in using the token
//            IWindowsIdentity windowsIdentity = null;
//
//            try {
//
//                windowsIdentity = _providers.doFilter(request, response);
//                if (windowsIdentity == null) {
//                    return;
//                }
//
//            } catch (Exception e) {
//                _log.warn("error logging in user: " + e.getMessage());
//                sendUnauthorized(response, true);
//                return;
//            }
//
//            IWindowsImpersonationContext ctx = null;
//            try {
//                if (!_allowGuestLogin && windowsIdentity.isGuest()) {
//                    _log.warn("guest login disabled: " +
//                              windowsIdentity.getFqn());
//                    sendUnauthorized(response, true);
//                    return;
//                }
//
//                _log.debug("logged in user: " + windowsIdentity.getFqn() +
//                           " (" + windowsIdentity.getSidString() + ")");
//
//                HttpSession session = request.getSession(true);
//                if (session == null) {
//                    throw new ServletException("Expected HttpSession");
//                }
//
//                Subject subject =
//                    (Subject)session.getAttribute("javax.security.auth.subject");
//                if (subject == null) {
//                    subject = new Subject();
//                }
//
//                WindowsPrincipal windowsPrincipal = null;
//                if (_impersonate) {
//                    windowsPrincipal =
//                            new AutoDisposableWindowsPrincipal(windowsIdentity,
//                                                               _principalFormat,
//                                                               _roleFormat);
//                } else {
//                    windowsPrincipal =
//                            new WindowsPrincipal(windowsIdentity, _principalFormat,
//                                                 _roleFormat);
//                }
//
//                _log.debug("roles: " + windowsPrincipal.getRolesString());
//                subject.getPrincipals().add(windowsPrincipal);
//                session.setAttribute("javax.security.auth.subject", subject);
//
//                _log.info("successfully logged in user: " +
//                          windowsIdentity.getFqn());
//
//                request.getSession().setAttribute(PRINCIPAL_SESSION_KEY,
//                                                  windowsPrincipal);
//
//                NegotiateRequestWrapper requestWrapper =
//                    new NegotiateRequestWrapper(request, windowsPrincipal);
//
//                if (_impersonate) {
//                    _log.debug("impersonating user");
//                    //					ctx = windowsIdentity.impersonate();
//                }
//
////                ImpersonationUtil.setCurrentWindowsIdentity(windowsIdentity);
//
//                chain.doFilter(requestWrapper, response);
//            } finally {
//                if (_impersonate && ctx != null) {
//                    _log.debug("terminating impersonation");
//                    //					ctx.RevertToSelf();
//                } else {
//                    //					windowsIdentity.dispose();
//                }
//            }
//
//            return;
//        }
//
//        _log.info("authorization required");
//        sendUnauthorized(response, false);
//    }
//
//    /**
//     * Filter for a previously logged on user.
//     * @param request
//     *  HTTP request.
//     * @param response
//     *  HTTP response.
//     * @param chain
//     *  Filter chain.
//     * @return
//     *  True if a user already authenticated.
//     * @throws ServletException
//     * @throws IOException
//     */
//    private boolean doFilterPrincipal(HttpServletRequest request,
//                                      HttpServletResponse response,
//                                      FilterChain chain) throws IOException,
//                                                                ServletException {
//        Principal principal = request.getUserPrincipal();
//        if (principal == null) {
//            HttpSession session = request.getSession(false);
//            if (session != null) {
//                principal =
//                        (Principal)session.getAttribute(PRINCIPAL_SESSION_KEY);
//            }
//        }
//
//        if (principal == null) {
//            // no principal in this request
//            return false;
//        }
//
//        if (_providers.isPrincipalException(request)) {
//            // the providers signal to authenticate despite an existing principal, eg. NTLM post
//            return false;
//        }
//
//        // user already authenticated
//
//        if (principal instanceof WindowsPrincipal) {
//            _log.info("previously authenticated Windows user: " +
//                      principal.getName());
//            WindowsPrincipal windowsPrincipal = (WindowsPrincipal)principal;
//
//            if (_impersonate && windowsPrincipal.getIdentity() == null) {
//                // This can happen when the session has been serialized then de-serialized
//                // and because the IWindowsIdentity field is transient. In this case re-ask an
//                // authentication to get a new identity.
//                return false;
//            }
//
//            NegotiateRequestWrapper requestWrapper =
//                new NegotiateRequestWrapper(request, windowsPrincipal);
//
//            IWindowsImpersonationContext ctx = null;
//            if (_impersonate) {
//                _log.debug("re-impersonating user");
////                ImpersonationUtil.setCurrentWindowsIdentity(windowsPrincipal.getIdentity());
//                //				ctx = windowsPrincipal.getIdentity().impersonate();
//            }
//            try {
//                chain.doFilter(requestWrapper, response);
//            } finally {
//                if (_impersonate && ctx != null) {
//                    _log.debug("terminating impersonation");
//                    //					ctx.RevertToSelf();
//                }
//            }
//        } else {
//            _log.info("previously authenticated user: " + principal.getName());
//            chain.doFilter(request, response);
//        }
//        return true;
//    }
//
//    @SuppressWarnings("rawtypes")
//    public void init(FilterConfig filterConfig) throws ServletException {
//        Map<String, String> implParameters = new HashMap<String, String>();
//
//        String authProvider = null;
//        String[] providerNames = null;
//        if (filterConfig != null) {
//            Enumeration parameterNames = filterConfig.getInitParameterNames();
//            while (parameterNames.hasMoreElements()) {
//                String parameterName = (String)parameterNames.nextElement();
//                String parameterValue =
//                    filterConfig.getInitParameter(parameterName);
//                _log.debug(parameterName + "=" + parameterValue);
//                if (parameterName.equals("principalFormat")) {
//                    _principalFormat = PrincipalFormat.valueOf(parameterValue);
//                } else if (parameterName.equals("roleFormat")) {
//                    _roleFormat = PrincipalFormat.valueOf(parameterValue);
//                } else if (parameterName.equals("allowGuestLogin")) {
//                    _allowGuestLogin = Boolean.parseBoolean(parameterValue);
//                } else if (parameterName.equals("impersonate")) {
//                    _impersonate = Boolean.parseBoolean(parameterValue);
//                } else if (parameterName.equals("securityFilterProviders")) {
//                    providerNames = parameterValue.split("\\s+");
//                } else if (parameterName.equals("authProvider")) {
//                    authProvider = parameterValue;
//                } else {
//                    implParameters.put(parameterName, parameterValue);
//                }
//            }
//        }
//
//        if (authProvider != null) {
//            try {
//                _auth =
//                        (IWindowsAuthProvider)Class.forName(authProvider).getConstructor().newInstance();
//            } catch (Exception e) {
//                _log.error("error loading '" + authProvider + "': " +
//                           e.getMessage());
//                throw new ServletException(e);
//            }
//        }
//
//        if (_auth == null) {
//            _auth = new WindowsAuthProviderImpl();
//        }
//
//        if (providerNames != null) {
//            _providers =
//                    new SecurityFilterProviderCollection(providerNames, _auth);
//        }
//
//        // create default providers if none specified
//        if (_providers == null) {
//            _log.debug("initializing default security filter providers");
//            _providers = new SecurityFilterProviderCollection(_auth);
//        }
//
//        // apply provider implementation parameters
//        for (Entry<String, String> implParameter : implParameters.entrySet()) {
//            String[] classAndParameter = implParameter.getKey().split("/", 2);
//            if (classAndParameter.length == 2) {
//                try {
//
//                    _log.debug("setting " + classAndParameter[0] + ", " +
//                               classAndParameter[1] + "=" +
//                               implParameter.getValue());
//
//                    SecurityFilterProvider provider =
//                        _providers.getByClassName(classAndParameter[0]);
//                    provider.initParameter(classAndParameter[1],
//                                           implParameter.getValue());
//
//                } catch (ClassNotFoundException e) {
//                    _log.error("invalid class: " + classAndParameter[0] +
//                               " in " + implParameter.getKey());
//                    throw new ServletException(e);
//                } catch (Exception e) {
//                    _log.error(classAndParameter[0] + ": error setting '" +
//                               classAndParameter[1] + "': " + e.getMessage());
//                    throw new ServletException(e);
//                }
//            } else {
//                _log.error("Invalid parameter: " + implParameter.getKey());
//                throw new ServletException("Invalid parameter: " +
//                                           implParameter.getKey());
//            }
//        }
//
//        _log.info("[waffle.servlet.NegotiateSecurityFilter] started");
//    }
//
//    /**
//     * Set the principal format.
//     * @param format
//     *  Principal format.
//     */
//    public void setPrincipalFormat(String format) {
//        _principalFormat = PrincipalFormat.valueOf(format);
//        _log.info("principal format: " + _principalFormat);
//    }
//
//    /**
//     * Principal format.
//     * @return
//     *  Principal format.
//     */
//    public PrincipalFormat getPrincipalFormat() {
//        return _principalFormat;
//    }
//
//    /**
//     * Set the principal format.
//     * @param format
//     *  Role format.
//     */
//    public void setRoleFormat(String format) {
//        _roleFormat = PrincipalFormat.valueOf(format);
//        _log.info("role format: " + _roleFormat);
//    }
//
//    /**
//     * Principal format.
//     * @return
//     *  Role format.
//     */
//    public PrincipalFormat getRoleFormat() {
//        return _roleFormat;
//    }
//
//    /**
//     * Send a 401 Unauthorized along with protocol authentication headers.
//     * @param response
//     *  HTTP Response
//     * @param close
//     *  Close connection.
//     */
//    private void sendUnauthorized(HttpServletResponse response,
//                                  boolean close) {
//        try {
//            _providers.sendUnauthorized(response);
//            if (close) {
//                response.setHeader("Connection", "close");
//            } else {
//                response.setHeader("Connection", "keep-alive");
//            }
//            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
//            response.flushBuffer();
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }
//    }
//
//    /**
//     * Windows auth provider.
//     * @return
//     *  IWindowsAuthProvider.
//     */
//    public IWindowsAuthProvider getAuth() {
//        return _auth;
//    }
//
//    /**
//     * Set Windows auth provider.
//     * @param provider
//     *  Class implements IWindowsAuthProvider.
//     */
//    public void setAuth(IWindowsAuthProvider provider) {
//        _auth = provider;
//    }
//
//    /**
//     * True if guest login is allowed.
//     * @return
//     *  True if guest login is allowed, false otherwise.
//     */
//    public boolean getAllowGuestLogin() {
//        return _allowGuestLogin;
//    }
//
//    /**
//     * Enable/Disable impersonation
//     * @param impersonate true to enable impersonation, false otherwise
//     */
//    public void setImpersonate(boolean impersonate) {
//        _impersonate = impersonate;
//    }
//
//    /**
//     * @return true if impersonation is enabled, false otherwise
//     */
//    public boolean getImpersonate() {
//        return _impersonate;
//    }
//
//    /**
//     * Security filter providers.
//     * @return
//     *  A collection of security filter providers.
//     */
//    public SecurityFilterProviderCollection getProviders() {
//        return _providers;
//    }
//}
