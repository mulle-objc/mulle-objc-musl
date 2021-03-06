#######
### none startup
#######
[ "${TRACE}" = 'YES' -o "${ENVIRONMENT_SH_TRACE}" = 'YES' ] && set -x  && : "$0" "$@"

#
# If mulle-env is broken, sometimes its nice just to source this file.
# If you're sourcing this manually on a regular basis, you're doing it wrong.
#
# We need some minimal stuff to get things going though:
#     sed, cut, tr, hostname, pwd, uname
#
if [ -z "${MULLE_UNAME}" ]
then
   MULLE_UNAME="`PATH=/bin:/usr/bin uname | \
                  PATH=/bin:/usr/bin cut -d_ -f1 | \
                  PATH=/bin:/usr/bin sed 's/64$//' | \
                  PATH=/bin:/usr/bin tr 'A-Z' 'a-z'`"
   export MULLE_UNAME
fi
if [ -z "${MULLE_HOSTNAME}" ]
then
   MULLE_HOSTNAME="`PATH=/bin:/usr/bin:/sbin:/usr/sbin hostname -s`"
   if [ "${MULLE_HOSTNAME:0:1}" = '.' ]
   then
      MULLE_HOSTNAME="_${MULLE_HOSTNAME}"
   fi
   export MULLE_HOSTNAME
fi
if [ -z "${MULLE_VIRTUAL_ROOT}" ]
then
   MULLE_VIRTUAL_ROOT="`PATH=/bin:/usr/bin pwd -P`"
   echo "Using ${MULLE_VIRTUAL_ROOT} as MULLE_VIRTUAL_ROOT for \
your convenience" >&2
fi

#
# now read in custom envionment (required)
#
. "${MULLE_VIRTUAL_ROOT}/.mulle/share/env/include-environment.sh"

#
# basic setup for interactive shells
#
case "${MULLE_SHELL_MODE}" in
   *INTERACTIVE*)
      #
      # Set PS1 so that we can see, that we are in a mulle-env
      #
      envname="`PATH=/bin:/usr/bin basename -- "${MULLE_VIRTUAL_ROOT}"`"

      case "${PS1}" in
         *\\h\[*)
         ;;

         *\\h*)
            PS1="$(sed 's/\\h/\\h\['${envname}'\]/' <<< '${PS1}' )"
         ;;

         *)
            PS1='\u@\h['${envname}'] \W$ '
         ;;
      esac
      export PS1

      unset envname

      # install cd catcher
      . "${MULLE_ENV_LIBEXEC_DIR}/mulle-env-cd.sh"
      unset MULLE_ENV_LIBEXEC_DIR

      # install mulle-env-reload

      alias mulle-env-reload='. "${MULLE_VIRTUAL_ROOT}/.mulle/share/env/include-environment.sh"'

      #
      # source in any bash completion files
      #
      DEFAULT_IFS="${IFS}"
      IFS=$'\n'
      # memo: nullglob not easily done on both bash and zsh
      for FILENAME in "${MULLE_VIRTUAL_ROOT}/.mulle/share/env/libexec"/*-bash-completion.sh
      do
         if [ -f "${FILENAME}" ]
         then
            . "${FILENAME}"
         fi
      done
      IFS="${DEFAULT_IFS}"

      unset DEFAULT_IFS
      unset FILENAME

      vardir="${MULLE_VIRTUAL_ROOT}/.mulle/var/${MULLE_HOSTNAME}"
      [ -d "${vardir}" ] || mkdir -p "${vardir}"

      HISTFILE="${vardir}/bash_history"
      export HISTFILE

      unset vardir

      #
      # show motd, if any
      #
      if [ -z "${NO_MOTD}" ]
      then
         if [ -f "${MULLE_VIRTUAL_ROOT}/.mulle/etc/env/motd" ]
         then
            cat "${MULLE_VIRTUAL_ROOT}/.mulle/etc/env/motd"
         else
            if [ -f "${MULLE_VIRTUAL_ROOT}/.mulle/share/env/motd" ]
            then
               cat "${MULLE_VIRTUAL_ROOT}/.mulle/share/env/motd"
            fi
         fi
      fi
   ;;
esac

# remove some uglies
unset NO_MOTD
unset TRACE
