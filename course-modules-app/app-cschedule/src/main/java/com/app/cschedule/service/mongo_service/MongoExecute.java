//package com.app.cschedule.service.mongo_service;
//
//import com.app.cschedule.common.util.IdUtil;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.domain.*;
//import org.springframework.stereotype.Component;
//
//import javax.annotation.Resource;
//import java.util.List;
//
///**
// * 测试mongo的使用，使用MongoRepository
// */
//@Slf4j
//@Component
//public class MongoExecute implements Runnable {
//
//
//    @Resource
//    private ResourcesRepository resourcesRepository;
//
//
//    @Override
//    public void run() {
////        insertOne();
////        insertBatch(50);
////        findAll();
////        update();
////        delete();
//    }
//
//    /**
//     * 删除
//     */
//    private void delete() {
//        List<ResourcesEntity> list = resourcesRepository.findAll();
//        if (!list.isEmpty()) {
//            resourcesRepository.deleteById(list.get(0).getId());
//        }
//    }
//
//    /**
//     * 更新
//     */
////    private void update(com.app.cschedule.entity.Resource resource) {
////        long id = 1729792683813355522L;
////        ResourcesEntity entity = resourcesRepository.findById(id)
////                .map(resourcesEntity -> {
////                    resourcesEntity.setResName(resource.getResName());
////                    resourcesEntity.setDownLinkPath();
////
////                    memberAccountLogEntity.setMemberName("半月无霜");
////                    memberAccountLogEntity.setDepositMoney(new BigDecimal("1000"));
////                    return memberAccountLogRepository.save(memberAccountLogEntity);
////                }).orElse(null);
////        log.info("修改后的信息，{}", memberAccountLogRepository.findById(id).get());
////    }
//
//    /**
//     * 查询所有
//     */
//    private void findAll(String resName) {
//        List<ResourcesEntity> list = resourcesRepository.findAll();
//        log.info("mongoDB全部资源数量：{}，详情：{}", list.size(), list);
//
//        // 添加条件，名字匹配
//        ResourcesEntity entity = new ResourcesEntity();
//        entity.setResName(resName);
//        List<ResourcesEntity> list1 = resourcesRepository.findAll(Example.of(entity));
//        log.info("mongoDB全部用户数量：{}，详情：{}", list1.size(), list1);
//
//        // 添加条件，名字模糊匹配，添加排序
////        MemberAccountLogEntity entity1 = new MemberAccountLogEntity();
////        entity1.setMemberName("35");
////        ExampleMatcher matcher = ExampleMatcher.matching()
////                .withMatcher(MemberAccountLogEntity.Fields.memberName, ExampleMatcher.GenericPropertyMatchers.contains());
////        Example<MemberAccountLogEntity> example = Example.of(entity1, matcher);
////        Sort sort = Sort.by(MemberAccountLogEntity.Fields.depositMoney).descending();
////        List<MemberAccountLogEntity> list2 = memberAccountLogRepository.findAll(example, sort);
////        log.info("mongoDB全部用户数量：{}，详情：{}", list2.size(), list2);
//
//        // 分页
////        Sort sort1 = Sort.by(MemberAccountLogEntity.Fields.totalConsumption).descending();
////        PageRequest page = PageRequest.of(0, 10, sort1);
////        Page<MemberAccountLogEntity> list3 = memberAccountLogRepository.findAll(page);
////        log.info("mongoDB全部用户数量：{}，当前分页详情：{}", list3.getTotalElements(), list3.getContent());
//
//        // 总数
////        long count = memberAccountLogRepository.count(example);
////        log.info("查询用户数量：{}", count);
//    }
//
//    /**
//     * 批量插入
//     */
////    private void insertBatch(int count) {
////        List<MemberAccountLogEntity> list = new ArrayList<>();
////        for (int i = 0; i < count; i++) {
////            MemberAccountLogEntity entity = new MemberAccountLogEntity();
////            entity.setId(IdUtil.getSnowflakeNextId());
////            entity.setMemberId(i + RandomUtil.randomString(6));
////            entity.setMemberName(i + RandomUtil.randomString(6));
////            entity.setTotalConsumption(RandomUtil.randomBigDecimal(BigDecimal.ZERO, BigDecimal.TEN));
////            entity.setDepositMoney(RandomUtil.randomBigDecimal(BigDecimal.ZERO, BigDecimal.TEN));
////            list.add(entity);
////        }
////        memberAccountLogRepository.insert(list);
////    }
//
//    /**
//     * 插入单挑
//     */
//    private void insertOne(String resName,String downLinkPath) {
//        ResourcesEntity entity = new ResourcesEntity();
//        entity.setId(IdUtil.getSnowflakeNextId());
//        entity.setResName(resName);
//        entity.setDownLinkPath(downLinkPath);
//        resourcesRepository.insert(entity);
//    }
//}