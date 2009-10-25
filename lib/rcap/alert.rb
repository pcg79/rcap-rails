module CAP
	class Alert
		include Validation


		ADDRESSES   = :addresses
		REFERENCES  = :references
		INCIDENTS   = :incidents
		SOURCE      = :source
		RESTRICTION = :restriction
		CODE        = :code
		NOTE        = :note
		IDENTIFIER  = :identifier
		SENDER      = :sender
		SENT        = :sent
		STATUS      = :status
		MSG_TYPE    = :msg_type
		SCOPE       = :scope
    INFOS       = :infos

		REQUIRED_ATOMIC_ATTRIBUTES = [ IDENTIFIER, SENDER, SENT, STATUS, MSG_TYPE, SCOPE ]
		OPTIONAL_ATOMIC_ATTRIBUTES = [ SOURCE, RESTRICTION, CODE, NOTE ]
		OPTIONAL_GROUP_ATTRIBUTES  = [ ADDRESSES, REFERENCES, INCIDENTS, INFOS ]
		ALL_ATTRIBUTES             = REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES + OPTIONAL_GROUP_ATTRIBUTES

		STATUS_ACTUAL   = "Actual"
		STATUS_EXERCISE = "Exercise"
		STATUS_SYSTEM   = "System"
		STATUS_TEST     = "Test"
		STATUS_DRAFT    = "Draft"
		ALL_STATUSES = [ STATUS_ACTUAL, STATUS_EXERCISE, STATUS_SYSTEM, STATUS_TEST, STATUS_DRAFT ]

		MSG_TYPE_ALERT  = "Alert"
		MSG_TYPE_UPDATE = "Update"
		MSG_TYPE_CANCEL = "Cancel"
		MSG_TYPE_ACK    = "Ack"
		MSG_TYPE_ERROR  = "Error"
		ALL_MSG_TYPES = [ MSG_TYPE_ALERT, MSG_TYPE_UPDATE, MSG_TYPE_CANCEL, MSG_TYPE_ACK, MSG_TYPE_ERROR ]  

		SCOPE_PUBLIC     = "Public"
		SCOPE_RESTRICTED = "Restricted"
		SCOPE_PRIVATE    = "Private"
		ALL_SCOPES = [ SCOPE_PUBLIC, SCOPE_PRIVATE, SCOPE_RESTRICTED ]

		attr_accessor( *( REQUIRED_ATOMIC_ATTRIBUTES + OPTIONAL_ATOMIC_ATTRIBUTES ))
		attr_reader( *OPTIONAL_GROUP_ATTRIBUTES )

		validates_presence_of( *REQUIRED_ATOMIC_ATTRIBUTES )
    validates_inclusion_of( STATUS, :in => ALL_STATUSES )
    validates_inclusion_of( MSG_TYPE, :in => ALL_MSG_TYPES )
    validates_inclusion_of( SCOPE, :in => ALL_SCOPES )
    validates_format_of( IDENTIFIER, :with => ALLOWED_CHARACTERS )
    validates_format_of( SENDER , :with => ALLOWED_CHARACTERS )
    validates_dependency_of( ADDRESSES, :on => SCOPE, :with_value => SCOPE_PRIVATE )
    validates_dependency_of( RESTRICTION, :on => SCOPE, :with_value => SCOPE_RESTRICTED )
    validates_collection_of( INFOS )

    XML_ELEMENT_NAME = 'alert'
    IDENTIFIER_ELEMENT_NAME = 'identifier'
    SENDER_ELEMENT_NAME = 'sender'
    SENT_ELEMENT_NAME = 'sent'
    STATUS_ELEMENT_NAME = 'status'
    MSG_TYPE_ELEMENT_NAME = 'msgType'
    SOURCE_ELEMENT_NAME = 'source'
    SCOPE_ELEMENT_NAME = 'scope'
    RESTRICTION_ELEMENT_NAME = 'restriction'
    ADDRESSES_ELEMENT_NAME = 'addresses'
    CODE_ELEMENT_NAME = 'code'
    NOTE_ELEMENT_NAME = 'note'
    REFERENCES_ELEMENT_NAME = 'references'
    INCIDENTS_ELEMENT_NAME = 'incidents'

    XPATH = '/cap:alert'

		def initialize( attributes = {})
			@identifier = attributes[ IDENTIFIER ] || UUIDTools::UUID.random_create.to_s
			@sender = attributes[ SENDER ]
			@sent = attributes[ SENT ] || Time.now
			@status = attributes[ STATUS ]
      @msg_type = attributes[ MSG_TYPE ]
			@scope = attributes[ SCOPE ]
			@source = attributes[ SOURCE ]
			@restriction = attributes[ SOURCE ]
			@addresses =  Array( attributes[ :addresses ])
			@references = Array( attributes[ :references ])
			@incidents = Array( attributes[ :incidents ])
			@infos = Array( attributes[ :infos ])
		end

    def to_xml_element
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_namespace( CAP::XMLNS )
      xml_element.add_element( IDENTIFIER_ELEMENT_NAME ).add_text( self.identifier ) 
      xml_element.add_element( SENDER_ELEMENT_NAME ).add_text( self.sender ) 
      xml_element.add_element( SENT_ELEMENT_NAME ).add_text( self.sent.to_s_for_cap ) 
      xml_element.add_element( STATUS_ELEMENT_NAME ).add_text( self.status ) 
      xml_element.add_element( MSG_TYPE_ELEMENT_NAME ).add_text( self.msg_type ) 
      xml_element.add_element( SOURCE_ELEMENT_NAME ).add_text( self.source ) if self.source
      xml_element.add_element( SCOPE_ELEMENT_NAME ).add_text( self.scope ) 
      xml_element.add_element( RESTRICTION_ELEMENT_NAME ).add_text( self.restriction ) if self.restriction
      unless self.addresses.empty?
        xml_element.add_element( ADDRESSES_ELEMENT_NAME ).add_text( self.addresses )
      end
      xml_element.add_element( CODE_ELEMENT_NAME ).add_text( self.code ) if self.code
      xml_element.add_element( NOTE_ELEMENT_NAME ).add_text( self.note ) if self.note
      unless self.references.empty?
        xml_element.add_element( REFERENCES_ELEMENT_NAME ).add_text( self.references )
      end
      unless self.incidents.empty?
        xml_element.add_element( INCIDENTS_ELEMENT_NAME ).add_text( self.incidents )
      end
      self.infos.each do |info|
        xml_element.add_element( info.to_xml_element )
      end
      xml_element
    end

    def to_xml_document
      xml_document = REXML::Document.new
      xml_document.add( REXML::XMLDecl.new )
      xml_document.add( self.to_xml_element )
      xml_document
    end

    def to_xml
      self.to_xml_document.to_s
    end
	end
end
