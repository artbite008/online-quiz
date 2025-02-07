package com.ksis.core.util;

import java.io.UnsupportedEncodingException;

import java.net.URLDecoder;
import java.net.URLEncoder;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.commons.lang.StringEscapeUtils;

import org.springframework.util.Assert;

/**
 * 各种格式的编码加码工具类.
 *
 * 集成Commons-Codec,Commons-Lang及JDK提供的编解码方法.
 *
 * @author Kanine
 */
public class EncodeUtils {

    private static final String ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    private static final String DEFAULT_URL_ENCODING = "UTF-8";

    /**
     * Hex编码.
     */
    public static String hexEncode(byte[] input) {
        return Hex.encodeHexString(input);
    }

    /**
     * Hex解码.
     */
    public static byte[] hexDecode(String input) {
        try {
            return Hex.decodeHex(input.toCharArray());
        } catch (DecoderException e) {
            throw new IllegalStateException("Hex Decoder exception", e);
        }
    }

    /**
     * Base64编码.
     */
    public static String base64Encode(byte[] input) {
        return StringUtils.newStringUtf8((Base64.encodeBase64(input)));
    }

    /**
     * Base64编码, URL安全(将Base64中的URL非法字符'+'和'/'转为'-'和'_', 见RFC3548).
     */
    public static String base64UrlSafeEncode(byte[] input) {
        return Base64.encodeBase64URLSafeString(input);
    }

    /**
     * Base64解码.
     */
    public static byte[] base64Decode(String input) {
        return Base64.decodeBase64(input);
    }

    /**
     * Base36 (0_9A_Z)编码.
     */

    public static String base36Encode(long num) {
        return alphabetEncode(num, 36);
    }

    /**
     * Base36 (0_9A_Z)解码.
     */
    public static long base36Decode(String str) {
        return alphabetDecode(str, 36);
    }

    /**
     * Base62(0_9A_Za_z)编码.
     */
    public static String base62Encode(long num) {
        return alphabetEncode(num, 62);
    }

    /**
     * Base62(0_9A_Za_z)解码
     */
    public static long base62Decode(String str) {
        return alphabetDecode(str, 62);
    }

    private static String alphabetEncode(long num, int base) {
        Assert.isTrue(num > 0, "num must be greater than 0.");

        StringBuilder sb = new StringBuilder();
        for (; num > 0; num /= base) {
            sb.append(ALPHABET.charAt((int)(num % base)));
        }

        return sb.toString();
    }

    private static long alphabetDecode(String str, int base) {
        Assert.hasText(str);

        long result = 0;
        for (int i = 0; i < str.length(); i++) {
            result += ALPHABET.indexOf(str.charAt(i)) * Math.pow(base, i);
        }

        return result;
    }

    /**
     * URL 编码, Encode默认为UTF-8.
     */
    public static String urlEncode(String input) {
        try {
            return URLEncoder.encode(input, DEFAULT_URL_ENCODING);
        } catch (UnsupportedEncodingException e) {
            throw new IllegalArgumentException("Unsupported Encoding Exception", e);
        }
    }

    /**
     * URL 解码, Encode默认为UTF-8.
     */
    public static String urlDecode(String input) {
        try {
            return URLDecoder.decode(input, DEFAULT_URL_ENCODING);
        } catch (UnsupportedEncodingException e) {
            throw new IllegalArgumentException("Unsupported Encoding Exception", e);
        }
    }

    /**
     * Html 转码.
     */
    public static String htmlEscape(String html) {
        return StringEscapeUtils.escapeHtml(html);
    }

    /**
     * Html 解码.
     */
    public static String htmlUnescape(String htmlEscaped) {
        return StringEscapeUtils.unescapeHtml(htmlEscaped);
    }

    /**
     * Xml 转码.
     */
    public static String xmlEscape(String xml) {
        return StringEscapeUtils.escapeXml(xml);
    }

    /**
     * Xml 解码.
     */
    public static String xmlUnescape(String xmlEscaped) {
        return StringEscapeUtils.unescapeXml(xmlEscaped);
    }

}
