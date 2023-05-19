#pragma endian little
#pragma eval_depth 100
struct Header {
    char signature[0x8];
    u64  first_chunk_number;
    u64  last_chunk_number;
    u64  next_record_identifier;
    u32  header_size;
    u16  minor_format_version;
    u16  major_format_version;
    u16  header_block_size;
    u16  number_of_chunks;
    u8   unknown[0x4C];
    u32  file_Flag;
    u32  checkSum;
    u8   unknown2[3968];
};

struct BinaryXML{
    u8 fragment_header_token;
    u8 major_version;
    u8 minor_version;
    u8 flags;
};

struct Event_Record{
    u32 signature;
    u32 size;
    u64 event_record_identifier;
    u64 written_data_amd_time;
    BinaryXML binaryxml;
};

struct Chunk{
    char signature[0x8];
    u64 first_event_record_number;
    u64 last_event_record_number;
    u64 first_event_record_identifier;
    u64 last_event_record_identifier;
    u32 header_size;
    u32 last_event_record_data_offset;
    u32 free_space_offset;
    u32 event_records_checksum;
    u8 unknown[64];
    u32 unknown2;
    u32 checksum;
    u8 common_string_offset_array[256];
    u8 templatePtr[128];
    Event_Record event_record;
};
struct Name{
    u32 unknown;
    u16 name_hash;
    u16 number_of_characters;
    u16 name[number_of_characters+1];
};
struct UnicodeTextString{
    u16 size;
    u16 character[size];
};
struct ValueText{
    u8 type;
    UnicodeTextString text;
};
struct NormalSubstitution{
    u16 identifier;
    u8 value_type;
};
struct OptionalSubstitution{
    u16 identifier;
    u8 value_type;
};

struct ContentString{
    u8 token;
    if(token == 0x05 || token == 0x45){
        ValueText value_text;
    }else if(token == 0x0D){
        NormalSubstitution normal_substitution;
    }else if(token == 0x0E){
        OptionalSubstitution optional_substitution;
    }
};
struct Attribute{
    u8 token;
    u32 name_offset;
    Name name;
    ContentString content_string;
    if(token == 0x46){
        Attribute attribute;
    }  
};
struct AttributeList{
    u32 data_size;
    Attribute attribute;
};

struct ElementStartAttribute{
    u16 dependency_identifier;
    u32 data_size;
    u32 name_offset;
    Name name;
    AttributeList attribute_list;
};


struct ElementStart{
    u16 dependency_identifier;
    u32 data_size;
    u32 name_offset;
    Name name;
};

struct Element{
    u8 token;
    if(token == 0x01){
        ElementStart element;     
    }else if(token == 0x41){
        ElementStartAttribute element_attribute;  
    }
    else if(token == 0x05 || token == 0x45){
        ValueText value_text;
    }else if(token == 0x0D){
        NormalSubstitution normal_substitution;
    }else if(token == 0x0E){
        OptionalSubstitution optional_substitution;
    }
    if(token==0x00){
    
    }else{
        Element elemet;
    }
};
struct TemplateValueDescriptor{
    u16 value_size;
    u8 value_type;
    u8 unknown;
};

struct TemplateInstanceData{
    u32 template_size;
    TemplateValueDescriptor template_value_descriptor[template_size];
};

struct TemplateInstance{
    u8 token;
    u8 unknown;
    u32 unknown2;
    u32 template_definition_data_offset;
    u32 unknown3;
    u128 template_identifier;
    u32 data_size;
    BinaryXML flagment_header;
    Element element;
    TemplateInstanceData template_instance_data;
};

struct Evtx {
    Header header;
    Chunk chunk;
    TemplateInstance template_instance;
};

Evtx evtx @ 0x00;