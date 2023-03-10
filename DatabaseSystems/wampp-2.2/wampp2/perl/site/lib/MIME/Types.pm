package MIME::Types;
use vars '$VERSION';
$VERSION = '1.06';

use strict;
use MIME::Type ();
use Carp;


#-------------------------------------------


my %list;
sub new(@) { (bless {}, shift)->init( {@_} ) }

sub init($)
{   my ($self, $args) = @_;

    unless(keys %list)
    {   local $_;
        local $/ = "\n";

        while(<MIME::Types::DATA>)
        {   s/\#.*//;
            next if m/^$/;

            my $os = s/^(\w+)\:// ? qr/$1/i : undef;

            my ($type, $extensions, $encoding) = split;
            if(   !$encoding
               && $extensions =~ m/^(?:base64|7bit|8bit|quoted\-printable)$/
              )
            {    # second column is empty
                 $encoding   = $extensions;
                 $extensions = undef;
            }

            next if $args->{only_complete} && ! $extensions;
            my $extent = $extensions ? [ split /\,/, $extensions ] : undef;
                    
            my $simplified = MIME::Type->simplified($type);
            push @{$list{$simplified}}, MIME::Type->new
              ( type       => $type
              , extensions => $extent
              , encoding   => $encoding
              , system     => $os
              );
        }
    }

    close DATA;
    $self;
}

my %type_index;
sub create_type_index()
{   my $self = shift;

    my @os_specific;
    while(my ($simple, $definitions) = each %list)
    {   foreach my $def (@$definitions)
        {   if(defined $def->system && $^O =~ $def->system)
            {   # OS specific definitions will overrule the
                # unspecific definitions, so must be postponed till
                # the end.
                push @os_specific, $def;
            }
            else
            {   $type_index{$_} = $def foreach $def->extensions;
            }
        }
    }

    foreach my $def (@os_specific)
    {   $type_index{$_} = $def foreach $def->extensions;
    }

    $self;
}

#-------------------------------------------


sub type($)
{  my $mime  = MIME::Type->simplified($_[1]) or return;
   return () unless exists $list{$mime};
   wantarray ? @{$list{$mime}} : $list{$mime}[0];
}

#-------------------------------------------


sub mimeTypeOf($)
{   my ($self, $name) = @_;
    $self->create_type_index unless keys %type_index;
    $name =~ s/.*\.//;
    $type_index{lc $name};
}

#-------------------------------------------


sub addType(@)
{   my $self = shift;

    foreach my $type (@_)
    {
        carp "WARNING: type $type already registered."
            if $type->isRegistered;

        my $simplified = $type->simplified;
        push @{$list{$simplified}}, $type;
    }

    %type_index = ();
    $self;
}

#-------------------------------------------


#-------------------------------------------

require Exporter;
use vars qw/@ISA @EXPORT_OK/;
@ISA       = qw(Exporter);
@EXPORT_OK = qw(by_suffix by_mediatype import_mime_types);

#-------------------------------------------


my $mime_types;

sub by_suffix($)
{   my $filename = shift;
    $mime_types ||= MIME::Types->new;
    my $mime     = $mime_types->mimeTypeOf($filename);

    my @data     = defined $mime ? ($mime->type, $mime->encoding) : ('','');
    wantarray ? @data : \@data;
}

#-------------------------------------------


sub by_mediatype($)
{   my $type = shift;
    my @found;

    if($type =~ m!/!)
    {   my $simplified = MIME::Type->simplified($type);
        my $mime = $list{$simplified};
        push @found, @$mime if defined $mime;
    }
    else
    {   my $mime = ref $type ? $type : qr/$type/i;
        @found = map {@{$list{$_}}}
                    grep {$_ =~ $mime}
                        keys %list;
    }

    my @data;
    foreach my $mime (@found)
    {   push @data, map { [$_, $mime->type, $mime->encoding] }
                       $mime->extensions;
    }

    wantarray ? @data : \@data;
}

#-------------------------------------------


sub import_mime_types($)
{   my $filename = shift;
    use Carp;
    croak <<'CROAK';
import_mime_types is not supported anymore: if you have types to add
please send them to the author.
CROAK
}

1;

#-------------------------------------------
# Internet media type registry is at
# <http://www.iana.org/assignments/media-types/> and
# F<ftp://ftp.iana.org/in-notes/iana/assignments/media-types/>.

__DATA__
application/access		mdf
application/activemessage
application/andrew-inset	ez
application/applefile					base64
application/atomicmail
application/batch-SMTP
application/beep+xml
application/bleeper		bleep			base64
application/cals-1840
application/cnrp+xml
application/commonground
application/cpl+xml
application/cu-seeme		csm,cu
application/cybercash
application/dca-rft
application/dec-dx
application/EDI-Consent
application/EDIFACT
application/EDI-X12
application/eshop
application/excel		xls,xlt			base64
application/font-tdpfr		pfr
application/futuresplash	spl
application/ghostview		
application/hep			hep
application/http
application/hyperstudio		stk
application/iges
application/imagemap		imagemap,imap		8bit
application/index
application/index.cmd
application/index.obj
application/index.response
application/index.vnd
application/iotp
application/ipp
application/isup
application/lotus-123		wks
application/mac-binhex40	hqx				8bit
application/mac-compactpro	cpt
application/macwriteii
application/marc
application/mathematica
application/mathcad		mcd				base64
application/mathematica-old
application/msword		doc,dot,wrd			base64
application/news-message-id
application/news-transmission
application/ocsp-request
application/ocsp-response
application/octet-stream	bin,dms,lha,lzh,exe,class,ani,pgp	base64
application/oda			oda
application/parityfec
application/pdf			pdf				base64
application/pagemaker		pm5,pt5,pm
application/pgp-encrypted					7bit
application/pgp-keys						7bit
application/pgp
application/pgp-signature	sig				base64
application/pkcs10
application/pkcs7-mime
application/pkcs7-signature
application/pkix-cert
application/pkixcmp
application/pkix-crl
application/postscript		ai,eps,ps			8bit
application/postscript		ps-z				base64
application/powerpoint		ppt,pps,pot				base64
application/prs.alvestrand.titrax-sheet
application/prs.cww		cw,cww
application/prs.nprend		rnd,rct
application/qsig
application/remote-printing
application/riscos
application/rtf			rtf				8bit
application/sdp
application/set-payment
application/set-payment-initiation
application/set-registration
application/set-registration-initiation
application/sgml
application/sgml-open-catalog	soc
application/slate
application/smil		smi,smil
application/timestamp-query
application/timestamp-reply
application/toolbook		tbk
application/tve-trigger
application/vemmi
application/VMSBACKUP		bck			base64
application/vnd.3gpp.pic-bw-large	plb
application/vnd.3gpp.pic-bw-small	psb
application/vnd.3gpp.pic-bw-var		pvb
application/vnd.3gpp.sms		sms
application/vnd.3M.Post-it-Notes
application/vnd.accpac.simply.aso
application/vnd.accpac.simply.imp
application/vnd.acucobol
application/vnd.acucorp		atc,acutc		7bit
application/vnd.adobe.xfdf	xfdf
application/vnd.aether.imp
application/vnd.amiga.amu	ami
application/vnd.anser-web-certificate-issue-initiation
application/vnd.anser-web-funds-transfer-initiation
application/vnd.audiograph
application/vnd.blueice.multipass	mpm
application/vnd.bmi
application/vnd.businessobjects
application/vnd.canon-cpdl
application/vnd.canon-lips
application/vnd.cinderella	cdy
application/vnd.claymore
application/vnd.commerce-battelle
application/vnd.commonspace
application/vnd.comsocaller
application/vnd.contact.cmsg
application/vnd.cosmocaller
application/vnd.ctc-posml
application/vnd.cups-postscript
application/vnd.cups-raster
application/vnd.cups-raw
application/vnd.curl		curl
application/vnd.cybank
application/vnd.data-vision.rdz	rdz
application/vnd.dna
application/vnd.dpgraph
application/vnd.dreamfactory	dfac
application/vnd.dxr
application/vnd.ecdis-update
application/vnd.ecowin.chart
application/vnd.ecowin.filerequest
application/vnd.ecowin.fileupdate
application/vnd.ecowin.series
application/vnd.ecowin.seriesrequest
application/vnd.ecowin.seriesupdate
application/vnd.enliven
application/vnd.epson.esf
application/vnd.epson.msf
application/vnd.epson.quickanime
application/vnd.epson.salt
application/vnd.epson.ssf
application/vnd.ericsson.quickcall
application/vnd.eudora.data
application/vnd.fdf
application/vnd.ffsns
application/vnd.FloGraphIt
application/vnd.framemaker
application/vnd.fsc.weblauch	fsc			7bit
application/vnd.fujitsu.oasys
application/vnd.fujitsu.oasys2
application/vnd.fujitsu.oasys3
application/vnd.fujitsu.oasysgp
application/vnd.fujitsu.oasysprs
application/vnd.fujixerox.ddd
application/vnd.fujixerox.docuworks
application/vnd.fujixerox.docuworks.binder
application/vnd.fut-misnet
application/vnd.grafeq
application/vnd.groove-account
application/vnd.groove-help
application/vnd.groove-identity-message
application/vnd.groove-injector
application/vnd.groove-tool-message
application/vnd.groove-tool-template
application/vnd.groove-vcard
application/vnd.hbci		hbci,hbc,kom,upa,pkd,bpd
application/vnd.hhe.lesson-player	les
application/vnd.hp-HPGL		plt,hpgl	
application/vnd.hp-hpid
application/vnd.hp-hps
application/vnd.hp-PCL
application/vnd.hp-PCLXL
application/vnd.httphone
application/vnd.hzn-3d-crossword
application/vnd.ibm.afplinedata
application/vnd.ibm.electronic-media	emm
application/vnd.ibm.MiniPay
application/vnd.ibm.modcap
application/vnd.ibm.secure-container	sc
application/vnd.informix-visionary
application/vnd.intercon.formnet
application/vnd.intertrust.digibox
application/vnd.intertrust.nncp
application/vnd.intu.qbo
application/vnd.intu.qfx
application/vnd.irepository.package+xml	irp
application/vnd.is-xpr
application/vnd.japannet-directory-service
application/vnd.japannet-jpnstore-wakeup
application/vnd.japannet-payment-wakeup
application/vnd.japannet-registration
application/vnd.japannet-registration-wakeup
application/vnd.japannet-setstore-wakeup
application/vnd.japannet-verification
application/vnd.japannet-verification-wakeup
application/vnd.jisp	jisp
application/vnd.kde.karbon	karbon
application/vnd.kde.kchart	chrt
application/vnd.kde.kformula	kfo
application/vnd.kde.kivio	flw
application/vnd.kde.kontour	kon
application/vnd.kde.kpresenter	ksp
application/vnd.kde.kspread	ksp
application/vnd.kde.kword	kwd,kwt
application/vnd.kenameapp	htke
application/vnd.koan
application/vnd.llamagraphics.life-balance.desktop	lbd
application/vnd.lotus-1-2-3
application/vnd.lotus-approach
application/vnd.lotus-freelance
application/vnd.lotus-notes
application/vnd.lotus-organizer
application/vnd.lotus-screencam
application/vnd.lotus-wordpro
application/vnd.mcd
application/vnd.mediastation.cdkey
application/vnd.meridian-slingshot
application/vnd.micrografx.flo	flo
application/vnd.micrografx.igx	igx
application/vnd.mif		mif
application/vnd.minisoft-hp3000-save
application/vnd.mitsubishi.misty-guard.trustweb
application/vnd.mobius.DAF
application/vnd.mobius.DIS
application/vnd.mobius.MBK
application/vnd.mobius.MQV
application/vnd.mobius.MSL
application/vnd.mobius.PLC
application/vnd.mobius.TXF
application/vnd.mophun.application	mpn
application/vnd.mophun.certificate	mpc
application/vnd.motorola.flexsuite
application/vnd.motorola.flexsuite.adsi
application/vnd.motorola.flexsuite.fis
application/vnd.motorola.flexsuite.gotap
application/vnd.motorola.flexsuite.kmr
application/vnd.motorola.flexsuite.ttc
application/vnd.motorola.flexsuite.wem
application/vnd.mozilla.xul+xml	xul
application/vnd.ms-artgalry	cil
application/vnd.ms-access	mda,mdb,mde
application/vnd.ms-asf		asf
application/vnd.mseq		mseq
application/vnd.ms-excel	xls,xlt
application/vnd.msign
application/vnd.ms-lrm		lrm
application/vnd.ms-powerpoint	ppt,pps,pot
application/vnd.ms-project	mpp
application/vnd.ms-tnef
application/vnd.ms-works
application/vnd.ms-wpl		wpl
application/vnd.musician
application/vnd.music-niff
application/vnd.netfpx
application/vnd.noblenet-directory
application/vnd.noblenet-sealer
application/vnd.noblenet-web
application/vnd.novadigm.EDM
application/vnd.novadigm.EDX
application/vnd.novadigm.EXT
application/vnd.obn
application/vnd.osa.netdeploy
application/vnd.palm		prc,pdb,pqa,oprc
application/vnd.pg.format
application/vnd.pg.osasli
application/vnd.powerbuilder6
application/vnd.powerbuilder6-s
application/vnd.powerbuilder7
application/vnd.powerbuilder75
application/vnd.powerbuilder75-s
application/vnd.powerbuilder7-s
application/vnd.previewsystems.box
application/vnd.publishare-delta-tree
application/vnd.pvi.ptid1	pti,ptid
application/vnd.pwg-multiplexed
application/vnd.pwg-xmhtml-print+xml
application/vnd.Quark.QuarkXPress	qxd,qxt,qwd,qwt,qxl,qxb		8bit
application/vnd.rapid
application/vnd.s3sms
application/vnd.seemail
application/vnd.sealed.net
application/vnd.shana.informed.formdata
application/vnd.shana.informed.formtemplate
application/vnd.shana.informed.interchange
application/vnd.shana.informed.package
application/vnd.smaf			mmf
application/vnd.sss-cod
application/vnd.sss-dtf
application/vnd.sss-ntf
application/vnd.street-stream
application/vnd.svd
application/vnd.swiftview-ics
application/vnd.triscape.mxs
application/vnd.trueapp
application/vnd.truedoc
application/vnd.ufdl
application/vnd.uplanet.alert
application/vnd.uplanet.alert-wbxml
application/vnd.uplanet.bearer-choice
application/vnd.uplanet.bearer-choice-wbxml
application/vnd.uplanet.cacheop
application/vnd.uplanet.cacheop-wbxml
application/vnd.uplanet.channel
application/vnd.uplanet.channel-wbxml
application/vnd.uplanet.list
application/vnd.uplanet.listcmd
application/vnd.uplanet.listcmd-wbxml
application/vnd.uplanet.list-wbxml
application/vnd.uplanet.signal
application/vnd.vcx
application/vnd.vectorworks
application/vnd.vidsoft.vidconference	vsc		8bit
application/vnd.visio			vsd,vst,vsw,vss
application/vnd.visionary		vis
application/vnd.vividence.scriptfile
application/vnd.vsf
application/vnd.wap.sic			sic
application/vnd.wap.slc			slc
application/vnd.wap.wbxml		wbxml
application/vnd.wap.wmlc		wmlc
application/vnd.wap.wmlscriptc		wmlsc
application/vnd.webturbo
application/vnd.wrq-hp3000-labelled
application/vnd.wt.stf
application/vnd.xara
application/vnd.xfdl
application/vnd.yellowriver-custom-menu
application/whoispp-query
application/whoispp-response
application/wita
application/wordperfect		wp
application/wordperfect5.1	wp5
application/wordperfect6.1	wp6
application/wordperfectd	wpd
application/x-123		wk
application/x400-bp
application/x-bcpio		bcpio
application/x-bzip2		bz2
application/x-cdlink		vcd
application/x-chess-pgn		pgn
application/x-compress		z,Z				base64
application/x-cpio		cpio				base64
application/x-csh		csh				8bit
application/x-debian-package	deb
application/x-director		dcr,dir,dxr
application/x-dvi		dvi				base64
application/x-futuresplash	spl
application/x-gtar		gtar,tgz,tbz2,tbz		base64
application/x-gunzip
application/x-gzip		gz				base64
application/x-hdf		hdf
application/xhtml+xml		xhtml				8bit
application/x-httpd-php		phtml,pht,php			8bit
application/x-ica		ica
application/x-javascript	js				8bit
application/x-koan		skp,skd,skt,skm
application/x-latex		latex				8bit
application/x-maker		frm,maker,frame,fm,fb,book,fbdoc
application/x-mif		mif
application/xml
application/xml-dtd
application/xml-external-parsed-entity
application/x-msdos-program	com,bat				8bit
application/x-msdos-program	exe				base64
application/x-msdownload	exe				base64
application/x-netcdf		nc,cdf
application/x-ns-proxy-autoconfig	pac
application/x-perl		pl,pm				8bit
application/quicktimeplayer	qtl
application/x-rar-compressed	rar				base64
application/x-shar		shar				8bit
application/x-shockwave-flash	swf
application/x-sh		sh				8bit
application/x-spss		sav,spp,sbs,sps,spo
application/x-stuffit		sit				base64
application/x-sv4cpio		sv4cpio				base64
application/x-sv4crc		sv4crc				base64
application/x-tar		tar				base64
application/x-tcl		tcl				8bit
application/x-texinfo		texinfo,texi			8bit
application/x-tex		tex				8bit
application/x-troff-man		man				8bit
application/x-troff-me		me
application/x-troff-ms		ms
application/x-troff		t,tr,roff			8bit
application/x-ustar		ustar				base64
application/x-wais-source	src
application/x-Wingz		wz
application/x-x509-ca-cert	crt				base64
application/zip			zip				base64
audio/32kadpcm
audio/amr			amr				base64
audio/amr-wb			awb				base64
audio/basic			au,snd				base64
audio/CN
audio/DAT12
audio/DVI4
audio/G.722.1
audio/G722
audio/G723
audio/G726-16
audio/G726-24
audio/G726-32
audio/G726-40
audio/G728
audio/G729
audio/G729D
audio/G729E
audio/GSM
audio/GSM-EFR
audio/l16			l16
audio/l20
audio/l24
audio/midi			mid,midi,kar			base64
audio/MP4A-LATM
audio/MPA
audio/mpa-robust
audio/mpeg			mpga,mp2,mp3			base64
audio/parityfec
audio/PCMA
audio/PCMU
audio/prs.sid			sid,psid
audio/QCELP
audio/RED
audio/telephone-event
audio/tone
audio/VDVI
audio/vnd.3gpp.iufp
audio/vnd.cisco.nse
audio/vnd.cns.anp1
audio/vnd.cns.inf1
audio/vnd.digital-winds		eol			7bit
audio/vnd.everad.plj		plj
audio/vnd.lucent.voice		lvp
audio/vnd.nortel.vbk		vbk
audio/vnd.nuera.ecelp4800	ecelp4800
audio/vnd.nuera.ecelp7470	ecelp7470
audio/vnd.nuera.ecelp9600	ecelp9600
audio/vnd.octel.sbc
audio/vnd.qcelp			qcp
audio/vnd.rhetorex.32kadpcm
audio/vnd.vmx.cvsd
audio/x-aiff			aif,aifc,aiff			base64
audio/x-pn-realaudio-plugin	rpm
audio/x-pn-realaudio		rm,ram				base64
audio/x-realaudio		ra				base64
audio/x-wav			wav				base64
chemical/x-pdb			pdb
chemical/x-xyz			xyz
drawing/dwf			dwf
image/bmp			bmp
image/cgm
image/g3fax
image/gif			gif				base64
image/ief			ief				base64
image/jpeg			jpeg,jpg,jpe			base64
image/naplps
image/png			png				base64
image/prs.btif
image/prs.pti
image/t38
image/tiff			tiff,tif			base64
image/tiff-fx
image/vnd.cns.inf2
image/vnd.djvu			djvu,djv
image/vnd.dgn			dgn
image/vnd.dwg			dwg
image/vnd.dxf
image/vnd.fastbidsheet
image/vnd.fpx
image/vnd.fst
image/vnd.fujixerox.edmics-mmr
image/vnd.fujixerox.edmics-rlc
image/vnd.glocalgraphics.pgb		pgb
image/vnd.mix
image/vnd.net-fpx
image/vnd.svf
image/vnd.wap.wbmp			wbmp
image/vnd.xiff
image/x-cmu-raster			ras
image/x-portable-anymap			pnm				base64
image/x-portable-bitmap			pbm				base64
image/x-portable-graymap		pgm				base64
image/x-portable-pixmap			ppm				base64
image/x-rgb				rgb				base64
image/x-xbitmap				xbm				7bit
image/x-xpixmap				xpm				8bit
image/x-xwindowdump			xwd				base64
message/delivery-status
message/disposition-notification
message/external-body							8bit
message/http
message/news								8bit
message/partial								8bit
message/rfc822								8bit
message/s-http
message/sipfrag
message/sip
model/iges				igs,iges
model/mesh				msh,mesh,silo
model/vnd.dwf
model/vnd.flatland.3dml
model/vnd.gdl
model/vnd.gs-gdl
model/vnd.gtw
model/vnd.mts
model/vnd.parasolid.transmit.binary	x_b,xmt_bin
model/vnd.parasolid.transmit.text	x_t,xmt_txt		quoted-printable
model/vnd.vtu
model/vrml				wrl,vrml
multipart/alternative							8bit
multipart/appledouble							8bit
multipart/byteranges
multipart/digest							8bit
multipart/encrypted
multipart/form-data
multipart/header-set
multipart/mixed								8bit
multipart/parallel							8bit
multipart/related
multipart/report
multipart/signed
multipart/voice-message
text/calendar
text/css				css				8bit
text/comma-separated-values		csv				8bit
text/directory
text/enriched
text/html				html,htm,htmlx,shtml,htx	8bit
text/plain			asc,txt,c,cc,h,hh,cpp,hpp,dat,hlp	8bit
text/prs.lines.tag
text/rfc822-headers
text/richtext				rtx				8bit
text/rtf				rtf
text/sgml				sgml,sgm
text/t140
text/tab-separated-values		tsv
text/uri-list
text/vnd.abc
text/vnd.curl
text/vnd.DMClientScript
text/vnd.flatland.3dml
text/vnd.fly
text/vnd.fmi.flexstor
text/vnd.in3d.3dml
text/vnd.in3d.spot
text/vnd.IPTC.NewsML
text/vnd.IPTC.NITF
text/vnd.latex-z
text/vnd.motorola.reflex
text/vnd.ms-mediapackage
text/vnd.net2phone.commcenter.command	ccc
text/vnd.sun.j2me.app-descriptor	jad				8bit
text/vnd.wap.si				si
text/vnd.wap.wmlscript			wmls
text/vnd.wap.wml			wml
text/xml				xml,dtd				8bit
text/xml-external-parsed-entity
text/x-setext				etx
text/x-sgml				sgml,sgm			8bit
text/x-vCalendar			vcs				8bit
text/x-vCard				vcf				8bit
video/dl				dl				base64
video/fli				fli				base64
video/gl				gl				base64
video/mpeg				mp2,mpe,mpeg,mpg		base64
video/pointer
video/quicktime				qt,mov				base64
video/vnd.fvt				fvt
video/vnd.motorola.video
video/vnd.motorola.videop
video/vnd.mpegurl			mxu,m4u				8bit
video/vnd.nokia.interleaved-multimedia	nim
video/vnd.objectvideo			mp4
video/vnd.vivo
video/x-ms-asf				asf,asx
video/x-msvideo				avi				base64
video/x-sgi-movie			movie				base64
x-conference/x-cooltalk			ice
x-world/x-vrml				wrl,vrml

# Exceptions

vms:text/plain				doc				8bit
mac:application/x-macbase64		bin
