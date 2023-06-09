## MDCS database migration

This set of notes provides some information on the migration of meta-genome database. A migration requires the full transformation of the data to fit a new schema that we want to implement. This will be necessary for a number of reasons:

1. Cosmetic change (e.g. field "Label/>")
2. New field being added
3. Fields being altered

The list above describes the types of transformation in order of complexity. I will go through the procedure for migration procedures for each of the listed items.

As the meta-genome project develops, we will want to add and remove existing fields. Therfore, a good understanding of migration is important. 

**Cautionary note:** the migration procedure is a full move and transform of the data - resulting in all data being changed to fit a new schema. **This means migrating is inherently risky and should not be rushed**. A backup of the linode server is in place. However, I would ensure snapshots are taken before migration begins.

There are two 'migration' protocol available in portal.meta-genome. Firstly, all data can be migrated to a new template. Alternatively, a new version of the current schema can be uploaded and migrated to. I think that the version controlled migration is superior for lower level changes. However, when a large change to the schema is needed, it may be worth underaking a full migration to a new schema.

Within the following sections I will walk through the version controlled procedure. Full schema migration is simpler but follows similar steps.

NOTE: I have used a local deployment of portal.meta-genome to test this procedure.

## cosmetic change

To be as useful as possible, this walkthrough is in context of the current meta-genome schema. Changing labels or placeholders is quite easy as the data itself and schema elements are not being changed. This serves as a good intro to the migration mechanism within portal.meta-genome. 

within /Resources/Cosmetic_change/ you will find 3 files:
 - dummy_data.xml - Sample xml form to be transformed
 - mecha-metagenome-schema31.xsd - schema 31 from portal.meta-genome
 - mecha-metagenome-schema31-cosmetic.xsd - schema 31 with cosmetic level change

In order to proceed with this demo, you should be relatively familiar with xsd schema and the uplaod procedure of new templates to portal.meta-genome. If not, refer to guides within meta-genome github library. To proceed, also upload the dummy_data.xml through your prefered method.

Firstly, lets have a look at the difference between mecha-metagenome-schema31.xsd and mecha-metagenome-schema31-cosmetic.xsd. In the image below, we see that the only difference is within the general-metamaterial-info element within the label field.


![img1](https://github.com/jac-111/database_migration/blob/main/images/img1.jpg?raw=true)




Now that we have an alternate version of the schema, we can create a new template version on portal.meta-genome. To do this, firstly go to the administration page. Then go to template list, under TEMPLATES, and find the version button associated with the schema to update (see below).

![img2](https://github.com/jac-111/database_migration/blob/main/images/img2.jpg?raw=true)

Now, click 'upload new version'. You will be able to upload the that the data is being transformed to match (mecha-metagenome-schema31-cosmetic.xsd). Then click the blue upload icon. 

![img3](https://github.com/jac-111/database_migration/blob/main/images/img3.jpg?raw=true)

From here, you will be presented with a table with 4 headings: Source template, Select data, Select XSLT, select target template. For these columns you should select the current version of the mecha-metagenome-schema31.xsd, the uploaded dummy data, nothing for the 3rd column (that will come later) and the target schema - this should be mecha-metagenome-schema31 (version 2). Below is an image of my setup - note that the different version are present here due to my testing of migration. 

![img4](https://github.com/jac-111/database_migration/blob/main/images/img4.jpg?raw=true)

At this stage, you are ready to migrate the data. Firstly click the validate button. This will compare all selected data against the new schema - ensuring that it matches. Assuming your data is compatible, you will see the text:
"Your task has been successfully executed 1 data succeeded. Start the migration by clicking on the "migrate" button below."
appear below the table. As is suggested, you can now migrate.

Upon clicking migrate, you are returned to the migration table. You can now return your records and see that the schema associated with dummy_data.xml has been updated to the current version of the template:

![img5](https://github.com/jac-111/database_migration/blob/main/images/img5.jpg?raw=true)

## New field being added

Within an xml schema, there are mandator and non-mandatory fields. When adding a new field, it is necessary to know which type of field you need to add. 

For non-mandatory field data migration, the procedure is exactly the same as a cosmetic level cange. This is true as the  added field can be left blank in existing submissions and still pass the validation. 

However, if the field is mandatory, we need to ensure that existing submissions are given a value for this field. This generates a problem as we presume to know the value that should be added. Each situation where this is necessary is likely to be unique. Therfore I will try to be as generic as possible to highlight the procedure.

In the figure below, you can see how I have altered the mecha-metagenome-schema31 to contain a mandatory field (new-field). 

![img6](https://github.com/jac-111/database_migration/blob/main/images/img6.jpg?raw=true)

For this type of migration, we require an xslt (transform) file. In the directory Resources/New_field the file add_field_migration.xsl contains a valid transformation file. This file firstly calls for the xml form to be copied then where the node that matches the string "general-metamaterial-info/new-field", input the line SAMPLE DATA INPUT with the appropriate tag.

![img7](https://github.com/jac-111/database_migration/blob/main/images/img7.jpg?raw=true)

In order to use this file, on the administration page, navigate to the "upload new XSLT" tab, then upload the file.Then, during the migration process as shown in cosmetic alteration, this xslt file should be passed during the migration as shown below:

![img8](https://github.com/jac-111/database_migration/blob/main/images/img8.jpg?raw=true)

## Altering Fields

In order to carry out a field alteration, we must use an xslt file. to demonstrate this, we will look at the file uploads within the schema. As shown below, there are mulitple file types to upload - image, topology etc. With each file upload we want to make it mandatory that if uploading a topology, the user should have to specify the type of file being uploaded. In addition, we are enforcing that the user should type either .cad, .step or .stl. 

![img9](https://github.com/jac-111/database_migration/blob/main/images/img9.jpg?raw=true)

Again, we need to use an xslt file in order to validate this schema. Below is a screen shot of the trnsformation file to be used. First, we are Copying the original file, then finding all elements with the XPath metamaterial-img/fileExtension and copying them in place. Finally we are finding all fileExtension Xpaths and replacing the content with .step. This can be done as we are early in the project, and it is known that all uploaded files are step.

![img10](https://github.com/jac-111/database_migration/blob/main/images/img10.jpg?raw=true)

I hope this helps to provide insight into the mechanism of data migration via mdcs.