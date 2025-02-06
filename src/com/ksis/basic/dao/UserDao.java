package com.ksis.basic.dao;

import java.util.List;

import org.hibernate.Query;

import org.springframework.stereotype.Repository;

import com.ksis.basic.entity.User;
import com.ksis.core.orm.hibernate.HibernateDao;

@Repository
public class UserDao extends HibernateDao<User, Long> {

    @SuppressWarnings( { "rawtypes" })
    public User getUserByName(String userName) {
        String hql = "from User where USERNAME='" + userName + "'";
        Query query = getSession().createQuery(hql);

        List list = query.list();

        if (list.size() > 0)
            return (User)list.get(0);
        else
            return null;
    }

    @SuppressWarnings( { "rawtypes" })
    public User getUserByEmail(String email) {
        String hql = "from User where EMAIL='" + email + "'";
        Query query = getSession().createQuery(hql);

        List list = query.list();

        if (list.size() > 0)
            return (User)list.get(0);
        else
            return null;
    }


}
