package com.ksis.basic.dao;

import java.util.List;

import org.hibernate.Query;

import org.springframework.stereotype.Repository;

import com.ksis.basic.entity.Choice;
import com.ksis.basic.entity.ExamDetail;
import com.ksis.basic.entity.ExamSummary;
import com.ksis.basic.entity.Favorite;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.core.orm.hibernate.HibernateDao;

@Repository
public class ExamDao extends HibernateDao<SortedExamDetail, Long> {

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public List<ExamSummary> getExamListByUserId(Integer creatorId) {
        String hql = "from ExamSummary where creatorId=" + creatorId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        return list;
    }

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public List<Favorite> getFavoriteListByUserId(Integer userId) {
        String hql = "from Favorite where user.userId=" + userId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        return list;
    }

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public ExamDetail getExamById(Integer examId) {
        String hql = "from ExamDetail where examId=" + examId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        return (ExamDetail)list.get(0);
    }

    @SuppressWarnings( { "rawtypes", "unchecked" })
    public SortedExamDetail getSortedExamById(Integer examId) {
        String hql = "from SortedExamDetail where examId=" + examId;
        Query query = getSession().createQuery(hql);

        List list = query.list();

        SortedExamDetail exam = (SortedExamDetail)list.get(0);
        for (SortedQuestion q : exam.getQuestions()) {
            if (q.getQuestionType() == 1 || q.getQuestionType() == 2) {
                String correctAnswer = q.getCorrectAnswer();
                if(correctAnswer!=null){
                    String[] correctAnswers = correctAnswer.split(",");
                    for (Choice ch : q.getChoices()) {
                        for (String correctKey : correctAnswers) {
                            if (correctKey.equals(String.valueOf(ch.getChoiceKey()))) {
                                ch.setCorrect(true);
                                break;
                            }
                        }
                    }
                }
            }
        }

        return exam;
    }


}
