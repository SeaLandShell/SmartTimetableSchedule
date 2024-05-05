SET NAMES utf8mb4;
use `ry-cloud`;
SET FOREIGN_KEY_CHECKS = 0;

drop table if exists course_user;
create table course_user (
	user_id           bigint(20)      not null auto_increment    comment '用户id',
  dept_id           bigint(20)      default null               comment '部门id',
  user_name         varchar(30)     default ''                 comment '用户姓名',
  nick_name         varchar(30)     default ''                 comment '用户昵称',
	password          varchar(100)    default ''                 comment '密码',
  user_type         varchar(2)      default '01'               comment '用户类型（00系统用户）（01教师）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
	stu_tu_number     varchar(50)     default ''                 comment '学工号',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
	birthday          date                                       comment '生日',
  status            char(1)         default '0'                comment '帐号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录ip',
  login_date        datetime                                   comment '最后登录时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
primary key (`user_id`)
) engine=innodb comment='用户表';



-- 创建课程表
DROP TABLE IF EXISTS `t_course`;
CREATE TABLE `t_course` (
    `course_id` char(30) NOT NULL COMMENT '课程ID',
    `course_num` char(10) NOT NULL COMMENT '课程编号',
    `course_name` char(30) NOT NULL COMMENT '课程名称',
    `course_pic` char(90) NOT NULL COMMENT '课程图片',
    `clazz_name` char(30) NOT NULL COMMENT '班级名称',
    `term` char(50) NOT NULL COMMENT '学期',
    `synopsis` text NULL COMMENT '课程简介',
    `arrive_num` int(11) NOT NULL DEFAULT 0 COMMENT '到课人数',
    `resource_num` int(11) NOT NULL DEFAULT 0 COMMENT '资源数量',
    `experience_num` int(11) NOT NULL DEFAULT 0 COMMENT '体验人数',
    `appraise` tinyint NOT NULL DEFAULT 0 COMMENT '评价',
    `teacher_id` bigint(20) NOT NULL COMMENT '教师ID',
		`teacher_name` char(30) NOT NULL COMMENT '教师名/成员名',
    PRIMARY KEY (`course_id`)
)engine=innodb comment='课程表';


drop table if exists calendar;
-- 日程表
create table calendar (
    calendar_id    char(30)   primary key   comment '日程id',
    user_id        bigint(20)               comment '用户id',
    title          text                     comment '日程数据'
)engine=innodb comment='日程表';



-- 创建成员表
DROP TABLE IF EXISTS `t_member`;
CREATE TABLE `t_member` (
    `user_id` bigint(20) NOT NULL COMMENT '用户ID',
    `course_id` char(30) NOT NULL COMMENT '课程ID',
    `arrive` int(11) NOT NULL DEFAULT 0 COMMENT '到课次数',
    `resource` int(11) NOT NULL DEFAULT 0 COMMENT '资源次数',
    `experience` int(11) NOT NULL DEFAULT 0 COMMENT '体验次数',
    `score` int(11) NOT NULL DEFAULT 0 COMMENT '评分',
    `remark` varchar(100) NULL COMMENT '备注',
    PRIMARY KEY (`user_id`, `course_id`)
)engine=innodb comment='成员表';

-- 创建通知表
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice` (
    `notice_id` char(30) NOT NULL COMMENT '通知ID',
    `author` char(30) NOT NULL COMMENT '作者',
    `content` text NOT NULL COMMENT '内容',
    `release_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '发布时间',
    `type` int NOT NULL DEFAULT 0 COMMENT '类型(1标识紧急通知，0标识普通通知)',
    `course_id` char(30) NOT NULL COMMENT '课程ID',
    PRIMARY KEY (`notice_id`)
)engine=innodb comment='通知表';

-- 创建资源表
DROP TABLE IF EXISTS `t_resource`;
CREATE TABLE `t_resource` (
    `res_id` char(30) NOT NULL COMMENT '资源ID',
    `res_name` char(100) NOT NULL COMMENT '资源名称',
    `res_size` bigint NOT NULL COMMENT '资源大小',
    `upload_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '上传时间',
    `down_link` char(2100) NOT NULL COMMENT '下载链接',
    `experience` int NOT NULL COMMENT '体验',
    `course_id` char(30) NOT NULL COMMENT '课程ID',
    PRIMARY KEY (`res_id`)
)engine=innodb comment='资源表';


-- 作业表
DROP TABLE IF EXISTS t_work;
CREATE TABLE t_work (
  work_id           CHAR(30)          NOT NULL               COMMENT '作业ID',
  course_id         CHAR(30)          NOT NULL               COMMENT '课程ID',
  work_name         VARCHAR(255)      NOT NULL               COMMENT '作业名',
  is_enabled        BOOLEAN           NOT NULL               COMMENT '是否启用true标识成员可见，false标识成员不可见',
  content           text              NOT NULL               COMMENT '作业要求(链接到mongodb的对应键)',
	link_resource     text              NOT NULL               COMMENT '作业附件链接(链接到mongodb的对应键)',
	start_time             datetime          NOT NULL               COMMENT '作业开始时间',
	end_time             datetime          NOT NULL               COMMENT '作业截止时间',
	state             bigint(20)        NOT NULL               COMMENT '是否过期（0标识未开始，1标识正在进行中，2标识已结束，3标识已重新提交）',
  gmt_create        datetime          DEFAULT                CURRENT_TIMESTAMP                 COMMENT '创建时间',
  gmt_modified      datetime          DEFAULT(CURRENT_TIMESTAMP)               ON UPDATE CURRENT_TIMESTAMP           COMMENT '更新时间',
  PRIMARY KEY (work_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业表';


-- 上传表
DROP TABLE IF EXISTS t_upload;
CREATE TABLE t_upload (
  upload_id       CHAR(30)          NOT NULL                COMMENT '上传ID',
	course_id         CHAR(30)          NOT NULL               COMMENT '课程ID',
  user_id         bigint(20)            NOT NULL              COMMENT '学生ID',
  work_id         CHAR(30)            NOT NULL                COMMENT '作业ID',
	work_name         text              NOT NULL               COMMENT '作业名',
	content           text              NOT NULL               COMMENT '学生作业内容(链接到mongodb的对应键)',
	link_resource     text              NOT NULL               COMMENT '作业附件链接(链接到mongodb的对应键)',
	appraise        text                NOT NULL                COMMENT '评价',
	criticism        text               NOT NULL                COMMENT '批语',
	score           int(11)             NOT NULL DEFAULT 0 COMMENT '评分',
  review          text                NOT NULL                COMMENT '审核状态(0标识未审核，1标识审核成功，2标识打回重新提交)',
  gmt_create        datetime          DEFAULT                CURRENT_TIMESTAMP                 COMMENT '创建时间',
  gmt_modified      datetime          DEFAULT(CURRENT_TIMESTAMP)               ON UPDATE CURRENT_TIMESTAMP           COMMENT '更新时间',
  PRIMARY KEY (upload_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='上传表';


-- 创建日志表
DROP TABLE IF EXISTS `t_log`;
CREATE TABLE `t_log` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `user_id` bigint(20) NULL COMMENT '用户ID',
    `module` varchar(60) NULL COMMENT '模块',
    `operation` varchar(60) NULL COMMENT '操作',
    `method` varchar(255) NULL COMMENT '方法',
    `params` varchar(255) NULL COMMENT '参数',
    `time` bigint NOT NULL COMMENT '时间',
    `ip` char(20) NOT NULL COMMENT 'IP',
    `create_time` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`)
)engine=innodb comment='日志表';

-- 针对某成员通知表
DROP TABLE IF EXISTS t_mnotice;
CREATE TABLE t_mnotice (
  mnotice_id      CHAR(30)          NOT NULL                COMMENT '通知ID',
	course_id       CHAR(30)          NOT NULL                COMMENT '课程ID',
  send_name       text            NOT NULL                COMMENT '发送者姓名',
  send_id         text            NOT NULL                COMMENT '发送者ID',
  receive_id      text            NOT NULL                COMMENT '接收者ID',
  receive_name    text            NOT NULL                COMMENT '接收者姓名',
  title           text            NOT NULL                COMMENT '标题',
  content         text            NOT NULL                COMMENT '内容',
  gmt_create        datetime          DEFAULT                CURRENT_TIMESTAMP                 COMMENT '创建时间',
  gmt_modified      datetime          DEFAULT(CURRENT_TIMESTAMP)               ON UPDATE CURRENT_TIMESTAMP           COMMENT '更新时间',
  PRIMARY KEY (mnotice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表';



-- 添加外键约束
ALTER TABLE `calendar` ADD CONSTRAINT `fk_calendar_t_user_1` FOREIGN KEY (`user_id`) REFERENCES `course_user` (`user_id`);
ALTER TABLE `t_member` ADD CONSTRAINT `fk_t_member_t_user_1` FOREIGN KEY (`user_id`) REFERENCES `course_user` (`user_id`);
ALTER TABLE `t_member` ADD CONSTRAINT `fk_t_member_t_course_1` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`);
ALTER TABLE `t_notice` ADD CONSTRAINT `fk_t_notice_t_course_1` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`);
ALTER TABLE `t_resource` ADD CONSTRAINT `fk_t_resource_t_course_1` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`);
ALTER TABLE `t_course` ADD CONSTRAINT `fk_t_course_t_user_1` FOREIGN KEY (`teacher_id`) REFERENCES `course_user` (`user_id`);
ALTER TABLE `t_work` ADD CONSTRAINT `fk_t_work_t_course_1` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`);
ALTER TABLE `t_upload` ADD CONSTRAINT `fk_t_upload_t_user_1` FOREIGN KEY (`user_id`) REFERENCES `course_user` (`user_id`);
ALTER TABLE `t_upload` ADD CONSTRAINT `fk_t_upload_t_work_1` FOREIGN KEY (`work_id`) REFERENCES `t_work` (`work_id`);
ALTER TABLE `t_log` ADD CONSTRAINT `fk_t_log_t_user_1` FOREIGN KEY (`user_id`) REFERENCES `course_user` (`user_id`);
ALTER TABLE `t_mnotice` ADD CONSTRAINT `fk_t_mnotice_t_course_1` FOREIGN KEY (`course_id`) REFERENCES `t_course` (`course_id`);

SET FOREIGN_KEY_CHECKS = 1;
