package com.app.cschedule.mapper;

import com.app.cschedule.common.support.BaseMapper;
import com.app.cschedule.entity.Mnotice;
import org.springframework.stereotype.Repository;

@Repository
@BaseMapper.Meta(table = "t_mnotice")
public interface MnoticeMapper extends BaseMapper<Mnotice> {

}
