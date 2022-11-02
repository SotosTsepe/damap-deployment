package at.ac.tuwien.damap.rest.dmp.mapper;

import at.ac.tuwien.damap.domain.Funding;
import at.ac.tuwien.damap.domain.Identifier;
import at.ac.tuwien.damap.domain.Project;
import at.ac.tuwien.damap.rest.dmp.domain.FundingDO;
import at.ac.tuwien.damap.rest.dmp.domain.IdentifierDO;
import at.ac.tuwien.damap.rest.dmp.domain.ProjectDO;
import lombok.experimental.UtilityClass;

@UtilityClass
public class ProjectDOMapper {

    public ProjectDO mapEntityToDO(Project project, ProjectDO projectDO) {
        projectDO.setId(project.id);
        projectDO.setUniversityId(project.getUniversityId());
        projectDO.setTitle(project.getTitle());
        projectDO.setDescription(project.getDescription());
        projectDO.setStart(project.getStart());
        projectDO.setEnd(project.getEnd());

        if (project.getFunding() != null) {
            FundingDO fundingDO = new FundingDO();
            mapEntityToDO(project.getFunding(), fundingDO);
            projectDO.setFunding(fundingDO);
        }

        return projectDO;
    }

    public FundingDO mapEntityToDO(Funding funding, FundingDO fundingDO) {
        fundingDO.setId(funding.id);
        fundingDO.setFundingStatus(funding.getFundingStatus());

        if (funding.getFunderIdentifier() != null) {
            IdentifierDO identifierFundingDO = new IdentifierDO();
            IdentifierDOMapper.mapEntityToDO(funding.getFunderIdentifier(), identifierFundingDO);
            fundingDO.setFunderId(identifierFundingDO);
        }

        if (funding.getGrantIdentifier() != null) {
            IdentifierDO identifierGrantDO = new IdentifierDO();
            IdentifierDOMapper.mapEntityToDO(funding.getGrantIdentifier(), identifierGrantDO);
            fundingDO.setGrantId(identifierGrantDO);
        }

        return fundingDO;
    }


    public Project mapDOtoEntity(ProjectDO projectDO, Project project){
        if (projectDO.getId() != null)
            project.id = projectDO.getId();
        project.setUniversityId(projectDO.getUniversityId());
        project.setTitle(projectDO.getTitle());
        project.setDescription(projectDO.getDescription());
        project.setStart(projectDO.getStart());
        project.setEnd(projectDO.getEnd());

        if (projectDO.getFunding() != null) {
            Funding funding = new Funding();
            if (project.getFunding() != null)
                funding = project.getFunding();
            mapDOtoEntity(projectDO.getFunding(), funding);
            project.setFunding(funding);
        } else
            project.setFunding(null);

        return project;
    }

    public Funding mapDOtoEntity(FundingDO fundingDO, Funding funding) {
        if (fundingDO.getId() != null)
            funding.id = fundingDO.getId();
        funding.setFundingStatus(fundingDO.getFundingStatus());

        if (fundingDO.getFunderId() != null) {
            Identifier identifierFunding = new Identifier();
            if (funding.getFunderIdentifier() != null)
                identifierFunding = funding.getFunderIdentifier();
            IdentifierDOMapper.mapDOtoEntity(fundingDO.getFunderId(), identifierFunding);
            funding.setFunderIdentifier(identifierFunding);
        } else
            funding.setFunderIdentifier(null);

        if (fundingDO.getGrantId() != null) {
            Identifier identifierGrant = new Identifier();
            if (funding.getGrantIdentifier() != null)
                identifierGrant = funding.getGrantIdentifier();
            IdentifierDOMapper.mapDOtoEntity(fundingDO.getGrantId(), identifierGrant);
            funding.setGrantIdentifier(identifierGrant);
        } else
            funding.setGrantIdentifier(null);

        return funding;
    }
}
