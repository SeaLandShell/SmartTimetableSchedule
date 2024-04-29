package com.app.cschedule.model;

import com.app.cschedule.entity.Member;
import com.app.cschedule.entity.Upload;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class MemberDTOO {


    private MemberDTO memberDTO;
    private Upload upload;

}
