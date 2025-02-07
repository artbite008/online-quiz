package com.ksis.core.util;

/**
 * Service层公用的Exception.
 *
 * 继承自RuntimeException,在函数中抛出会触发Spring的事务管理器引起事务回退.
 *
 * @author Kanine
 */
public class ServiceException extends RuntimeException {

    private static final long serialVersionUID = 4146548369811741865L;

    public ServiceException() {
        super();
    }

    public ServiceException(String message) {
        super(message);
    }

    public ServiceException(Throwable cause) {
        super(cause);
    }

    public ServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
