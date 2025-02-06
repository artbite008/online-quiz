package com.ksis.basic.service;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ksis.basic.dao.ChoiceDao;
import com.ksis.basic.dao.ExamDao;
import com.ksis.basic.dao.QuestionDao;
import com.ksis.basic.dao.UserDao;
import com.ksis.basic.entity.Choice;
import com.ksis.basic.entity.ExamDetail;
import com.ksis.basic.entity.ExamSummary;
import com.ksis.basic.entity.Favorite;
import com.ksis.basic.entity.SortedQuestion;
import com.ksis.basic.entity.SortedExamDetail;
import com.ksis.basic.entity.User;
import com.ksis.core.orm.Page;
import com.ksis.core.util.ServiceException;

/**
 * 基础数据字典的Manager
 * @author xuxians
 */
@Service
@Transactional
public class KsisBaseManager {

    @Autowired
    private ExamDao examDao;

    @Autowired
    private ChoiceDao choiceDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private QuestionDao questionDao;

    private static Logger logger = LoggerFactory.getLogger(KsisBaseManager.class);

    public SortedExamDetail saveExam(SortedExamDetail exam) {
        SortedExamDetail ex = examDao.saveReturn(exam);
        examDao.flush();
        return ex;
    }

    public User saveUser(User user) {
        User u = userDao.saveReturn(user);
        userDao.flush();
        return u;
    }

    public SortedQuestion saveQuestion(SortedQuestion question) {
        SortedQuestion ques = questionDao.saveReturn(question);
        questionDao.flush();
        return ques;
    }

    public Choice saveChoice(Choice choice) {
        Choice ch = choiceDao.saveReturn(choice);
        choiceDao.flush();
        return ch;
    }

    public ExamDetail getExamById(Integer examId) {
        return examDao.getExamById(examId);
    }

    public Choice getChoiceById(Integer choiceId) {
        return choiceDao.getChoiceById(choiceId);
    }

    public SortedExamDetail getSortedExamById(Integer examId) {
        return examDao.getSortedExamById(examId);
    }

    public void deleteQuestion(SortedQuestion question) {
        questionDao.delete(question);
        questionDao.flush();
    }

    public void deleteExam(SortedExamDetail exam) {
        examDao.delete(exam);
        examDao.flush();
    }

    public void deleteChoice(Choice choice) {
        choiceDao.delete(choice);
        choiceDao.flush();
    }

    public SortedQuestion getQuestionById(Integer questionId) {
        return questionDao.getQuestionById(questionId);
    }

    public User getUserByName(String userName) {
        return userDao.getUserByName(userName);
    }

    public User getUserByEmail(String email) {
        return userDao.getUserByEmail(email);
    }

    public List<ExamSummary> getCreatedExamList(Integer creatorId) {
        return examDao.getExamListByUserId(creatorId);
    }

    public List<Favorite> getFavoriteListByUserId(Integer userId) {
        return examDao.getFavoriteListByUserId(userId);
    }

}
