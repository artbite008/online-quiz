package com.ksis.core.util.web;

import java.io.IOException;

import java.util.Properties;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * 字符串编码过滤器.
 *
 * @author Kanine
 */
public class CharacterEncodingFilter extends OncePerRequestFilter {

    private String encoding;

    private boolean forceEncoding = false;

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }

    public void setForceEncoding(boolean forceEncoding) {
        this.forceEncoding = forceEncoding;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        Properties prop = System.getProperties();
        prop.put("file.encoding", "utf-8"); // 解决sitemesh在weblogic下的乱码问题
        if ((this.encoding != null) && (((this.forceEncoding) || (request.getCharacterEncoding() == null)))) {
            request.setCharacterEncoding(this.encoding);
            if (this.forceEncoding) {
                response.setCharacterEncoding(this.encoding);
            }
        }
        filterChain.doFilter(request, response);
    }

}
