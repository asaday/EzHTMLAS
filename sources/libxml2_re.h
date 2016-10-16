#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
	HTML_PARSE_RECOVER  = 1<<0, /* Relaxed parsing */
	HTML_PARSE_NODEFDTD = 1<<2, /* do not default a doctype if not found */
	HTML_PARSE_NOERROR	= 1<<5,	/* suppress error reports */
	HTML_PARSE_NOWARNING= 1<<6,	/* suppress warning reports */
	HTML_PARSE_PEDANTIC	= 1<<7,	/* pedantic error reporting */
	HTML_PARSE_NOBLANKS	= 1<<8,	/* remove blank nodes */
	HTML_PARSE_NONET	= 1<<11,/* Forbid network access */
	HTML_PARSE_NOIMPLIED= 1<<13,/* Do not add implied html/body... elements */
	HTML_PARSE_COMPACT  = 1<<16,/* compact small text nodes */
	HTML_PARSE_IGNORE_ENC=1<<21 /* ignore internal document encoding hint */
} htmlParserOption;

typedef enum {
	XML_ELEMENT_NODE=		1,
	XML_ATTRIBUTE_NODE=		2,
	XML_TEXT_NODE=		3,
	XML_CDATA_SECTION_NODE=	4,
	XML_ENTITY_REF_NODE=	5,
	XML_ENTITY_NODE=		6,
	XML_PI_NODE=		7,
	XML_COMMENT_NODE=		8,
	XML_DOCUMENT_NODE=		9,
	XML_DOCUMENT_TYPE_NODE=	10,
	XML_DOCUMENT_FRAG_NODE=	11,
	XML_NOTATION_NODE=		12,
	XML_HTML_DOCUMENT_NODE=	13,
	XML_DTD_NODE=		14,
	XML_ELEMENT_DECL=		15,
	XML_ATTRIBUTE_DECL=		16,
	XML_ENTITY_DECL=		17,
	XML_NAMESPACE_DECL=		18,
	XML_XINCLUDE_START=		19,
	XML_XINCLUDE_END=		20
	,XML_DOCB_DOCUMENT_NODE=	21
} xmlElementType;

typedef unsigned char xmlChar;

typedef enum {
	XML_ELEMENT_TYPE_UNDEFINED = 0,
	XML_ELEMENT_TYPE_EMPTY = 1,
	XML_ELEMENT_TYPE_ANY,
	XML_ELEMENT_TYPE_MIXED,
	XML_ELEMENT_TYPE_ELEMENT
} xmlElementTypeVal;

typedef enum {
	XML_ELEMENT_CONTENT_PCDATA = 1,
	XML_ELEMENT_CONTENT_ELEMENT,
	XML_ELEMENT_CONTENT_SEQ,
	XML_ELEMENT_CONTENT_OR
} xmlElementContentType;

typedef enum {
	XML_ELEMENT_CONTENT_ONCE = 1,
	XML_ELEMENT_CONTENT_OPT,
	XML_ELEMENT_CONTENT_MULT,
	XML_ELEMENT_CONTENT_PLUS
} xmlElementContentOccur;


typedef struct _xmlElementContent xmlElementContent;
typedef xmlElementContent *xmlElementContentPtr;
struct _xmlElementContent {
	xmlElementContentType     type;	/* PCDATA, ELEMENT, SEQ or OR */
	xmlElementContentOccur    ocur;	/* ONCE, OPT, MULT or PLUS */
	const xmlChar             *name;	/* Element name */
	struct _xmlElementContent *c1;	/* first child */
	struct _xmlElementContent *c2;	/* second child */
	struct _xmlElementContent *parent;	/* parent */
	const xmlChar             *prefix;	/* Namespace prefix */
};

typedef enum {
	XML_ATTRIBUTE_CDATA = 1,
	XML_ATTRIBUTE_ID,
	XML_ATTRIBUTE_IDREF	,
	XML_ATTRIBUTE_IDREFS,
	XML_ATTRIBUTE_ENTITY,
	XML_ATTRIBUTE_ENTITIES,
	XML_ATTRIBUTE_NMTOKEN,
	XML_ATTRIBUTE_NMTOKENS,
	XML_ATTRIBUTE_ENUMERATION,
	XML_ATTRIBUTE_NOTATION
} xmlAttributeType;

typedef enum {
	XML_ATTRIBUTE_NONE = 1,
	XML_ATTRIBUTE_REQUIRED,
	XML_ATTRIBUTE_IMPLIED,
	XML_ATTRIBUTE_FIXED
} xmlAttributeDefault;

typedef struct _xmlEnumeration xmlEnumeration;
typedef xmlEnumeration *xmlEnumerationPtr;
struct _xmlEnumeration {
	struct _xmlEnumeration    *next;	/* next one */
	const xmlChar            *name;	/* Enumeration name */
};

typedef struct _xmlAttribute xmlAttribute;
typedef xmlAttribute *xmlAttributePtr;
struct _xmlAttribute {
	void           *_private;	        /* application data */
	xmlElementType          type;       /* XML_ATTRIBUTE_DECL, must be second ! */
	const xmlChar          *name;	/* Attribute name */
	struct _xmlNode    *children;	/* NULL */
	struct _xmlNode        *last;	/* NULL */
	struct _xmlDtd       *parent;	/* -> DTD */
	struct _xmlNode        *next;	/* next sibling link  */
	struct _xmlNode        *prev;	/* previous sibling link  */
	struct _xmlDoc          *doc;       /* the containing document */
	
	struct _xmlAttribute  *nexth;	/* next in hash table */
	xmlAttributeType       atype;	/* The attribute type */
	xmlAttributeDefault      def;	/* the default */
	const xmlChar  *defaultValue;	/* or the default value */
	xmlEnumerationPtr       tree;       /* or the enumeration tree if any */
	const xmlChar        *prefix;	/* the namespace prefix if any */
	const xmlChar          *elem;	/* Element holding the attribute */
};

typedef struct _xmlElement xmlElement;
typedef xmlElement *xmlElementPtr;
struct _xmlElement {
	void           *_private;	        /* application data */
	xmlElementType          type;       /* XML_ELEMENT_DECL, must be second ! */
	const xmlChar          *name;	/* Element name */
	struct _xmlNode    *children;	/* NULL */
	struct _xmlNode        *last;	/* NULL */
	struct _xmlDtd       *parent;	/* -> DTD */
	struct _xmlNode        *next;	/* next sibling link  */
	struct _xmlNode        *prev;	/* previous sibling link  */
	struct _xmlDoc          *doc;       /* the containing document */
	
	xmlElementTypeVal      etype;	/* The type */
	xmlElementContentPtr content;	/* the allowed element content */
	xmlAttributePtr   attributes;	/* List of the declared attributes */
	const xmlChar        *prefix;	/* the namespace prefix if any */
#ifdef LIBXML_REGEXP_ENABLED
	xmlRegexpPtr       contModel;	/* the validating regexp */
#else
	void	      *contModel;
#endif
};


/**
 * XML_LOCAL_NAMESPACE:
 *
 * A namespace declaration node.
 */
#define XML_LOCAL_NAMESPACE XML_NAMESPACE_DECL
typedef xmlElementType xmlNsType;


typedef struct _xmlNs xmlNs;
typedef xmlNs *xmlNsPtr;
struct _xmlNs {
	struct _xmlNs  *next;	/* next Ns link for this node  */
	xmlNsType      type;	/* global or local */
	const xmlChar *href;	/* URL for the namespace */
	const xmlChar *prefix;	/* prefix for the namespace */
	void           *_private;   /* application data */
	struct _xmlDoc *context;		/* normally an xmlDoc */
};

typedef struct _xmlDoc xmlDoc;
typedef xmlDoc *xmlDocPtr;
struct _xmlDoc {
	void           *_private;	/* application data */
	xmlElementType  type;       /* XML_DOCUMENT_NODE, must be second ! */
	char           *name;	/* name/filename/URI of the document */
	struct _xmlNode *children;	/* the document tree */
	struct _xmlNode *last;	/* last child link */
	struct _xmlNode *parent;	/* child->parent link */
	struct _xmlNode *next;	/* next sibling link  */
	struct _xmlNode *prev;	/* previous sibling link  */
	struct _xmlDoc  *doc;	/* autoreference to itself */
	
	/* End of common part */
	int             compression;/* level of zlib compression */
	int             standalone; /* standalone document (no external refs)
				     1 if standalone="yes"
				     0 if standalone="no"
								 -1 if there is no XML declaration
								 -2 if there is an XML declaration, but no
								 standalone attribute was specified */
	struct _xmlDtd  *intSubset;	/* the document internal subset */
	struct _xmlDtd  *extSubset;	/* the document external subset */
	struct _xmlNs   *oldNs;	/* Global namespace, the old way */
	const xmlChar  *version;	/* the XML version string */
	const xmlChar  *encoding;   /* external initial encoding, if any */
	void           *ids;        /* Hash table for ID attributes if any */
	void           *refs;       /* Hash table for IDREFs attributes if any */
	const xmlChar  *URL;	/* The URI for that document */
	int             charset;    /* encoding of the in-memory content
								 actually an xmlCharEncoding */
	struct _xmlDict *dict;      /* dict used to allocate names or NULL */
	void           *psvi;	/* for type/PSVI informations */
	int             parseFlags;	/* set of xmlParserOption used to parse the
								 document */
	int             properties;	/* set of xmlDocProperties for this document
								 set at the end of parsing */
};

typedef struct _xmlNode xmlNode;
typedef xmlNode *xmlNodePtr;
struct _xmlNode {
	void           *_private;	/* application data */
	xmlElementType   type;	/* type number, must be second ! */
	const xmlChar   *name;      /* the name of the node, or the entity */
	struct _xmlNode *children;	/* parent->childs link */
	struct _xmlNode *last;	/* last child link */
	struct _xmlNode *parent;	/* child->parent link */
	struct _xmlNode *next;	/* next sibling link  */
	struct _xmlNode *prev;	/* previous sibling link  */
	struct _xmlDoc  *doc;	/* the containing document */
	
	/* End of common part */
	xmlNs           *ns;        /* pointer to the associated namespace */
	xmlChar         *content;   /* the content */
	struct _xmlAttr *properties;/* properties list */
	xmlNs           *nsDef;     /* namespace definitions on this node */
	void            *psvi;	/* for type/PSVI informations */
	unsigned short   line;	/* line number */
	unsigned short   extra;	/* extra data for XPath/XSLT */
};


typedef struct _xmlDOMWrapCtxt xmlDOMWrapCtxt;
typedef xmlDOMWrapCtxt *xmlDOMWrapCtxtPtr;


typedef xmlDocPtr htmlDocPtr;

htmlDocPtr htmlReadDoc		(const xmlChar *cur,
							 const char *URL,
							 const char *encoding,
							 int options);


htmlDocPtr htmlReadMemory		(const char *buffer,
					 int size,
					 const char *URL,
					 const char *encoding,
					 int options);

 void
xmlFreeDoc		(xmlDocPtr cur);

#ifdef __cplusplus
}
#endif
