package at.ac.tuwien.damap.rest.dmp.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class StorageDO extends HostDO {

    private Long internalStorageId;
}
