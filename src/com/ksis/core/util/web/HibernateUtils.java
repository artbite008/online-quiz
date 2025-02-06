package com.ksis.core.util.web;

import java.util.Collection;
import java.util.Iterator;

import org.springframework.util.Assert;

import com.ksis.core.orm.IdEntity;
import com.ksis.core.util.reflection.ReflectionUtils;

/**
 * 用于项目的Hibernate工具类.
 *
 * @author Kanine
 */
public class HibernateUtils {

    /**
     * 根据对象ID集合, 整理合并集合.
     *
     * 页面发送变更后的子对象id列表时,在Hibernate中删除整个原来的子对象集合再根据页面id列表创建一个全新的集合这种看似最简单的做法是不行的.
     * 因此采用如此的整合算法：在源集合中删除id不在目标集合中的对象,根据目标集合中的id创建对象并添加到源集合中.
     * 因为新建对象只有ID被赋值, 因此本函数不适合于cascade-save-or-update自动持久化子对象的设置.
     *
     * @param srcObjects - 源集合,元素为对象.
     * @param checkedIds  - 目标集合,元素为ID.
     * @param clazz  - 集合中对象的类型,必须为IdEntity子类
     */
    public static <T extends IdEntity> void mergeByCheckedIds(final Collection<T> srcObjects,
                                                              final Collection<Long> checkedIds,
                                                              final Class<T> clazz) {

        //参数校验
        Assert.notNull(srcObjects, "scrObjects不能为空");
        Assert.notNull(clazz, "clazz不能为空");

        //目标集合为空, 删除源集合中所有对象后直接返回.
        if (checkedIds == null) {
            srcObjects.clear();
            return;
        }

        //遍历源对象集合,如果其id不在目标ID集合中的对象删除.
        //同时,在目标集合中删除已在源集合中的id,使得目标集合中剩下的id均为源集合中没有的id.
        Iterator<T> srcIterator = srcObjects.iterator();
        try {
            while (srcIterator.hasNext()) {
                T element = srcIterator.next();
                Long id = element.getId();

                if (!checkedIds.contains(id)) {
                    srcIterator.remove();
                } else {
                    checkedIds.remove(id);
                }
            }

            //ID集合目前剩余的id均不在源集合中,创建对象,为id属性赋值并添加到源集合中.
            for (Long id : checkedIds) {
                T element = clazz.newInstance();
                element.setId(id);
                srcObjects.add(element);
            }
        } catch (Exception e) {
            throw ReflectionUtils.convertReflectionExceptionToUnchecked(e);
        }
    }

}

