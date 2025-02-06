package com.ksis.basic.dao;

import java.util.List;

import org.hibernate.Query;

import org.springframework.stereotype.Repository;

import com.ksis.basic.entity.SortedQuestion;
import com.ksis.core.orm.hibernate.HibernateDao;

@Repository
public class QuestionDao extends HibernateDao<SortedQuestion, Long> {

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public SortedQuestion getQuestionById(Integer quesId) {
        String hql = "from SortedQuestion where questionId=" + quesId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        return (SortedQuestion)list.get(0);
    }
}
