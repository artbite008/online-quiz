package com.ksis.basic.dao;

import java.util.List;

import org.hibernate.Query;

import org.springframework.stereotype.Repository;

import com.ksis.basic.entity.Choice;
import com.ksis.core.orm.hibernate.HibernateDao;

@Repository
public class ChoiceDao extends HibernateDao<Choice, Long> {

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public Choice getChoiceById(Integer choiceId) {
        String hql = "from Choice where choiceId=" + choiceId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        return (Choice)list.get(0);
    }
}
