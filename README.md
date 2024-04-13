Artigo: https://suporte.ivancarlos.com.br/hc/pt-br/articles/25861271868301

<p>
  Como vimos
  <a href="https://suporte.ivancarlos.com.br/hc/pt-br/articles/25731464664461" target="_blank" rel="noopener noreferrer">aqui</a>,
  o Rclone é uma poderosa ferramenta de cópia de arquivos que pode servir como
  backup para enviar arquivos a diferentes provedores, como BackBlaze entre muitos
  outros.
</p>
<p>
  Aqui descrevo uma forma de verificar múltiplos repositórios configurados no Rclone,
  no caso, do BackBlaze, e enviar uma mensagem de e-mail se algum deles não estiver
  com arquivos mais recentes que 2 dias.
</p>
<p>
  Note que estamos utilizando o awscli para mandarmos e-mails de uma instância
  diretamente via AWS SES (Simple Email Service), então, uma breve configuração
  para instalar e configurar o
  <a href="https://aws.amazon.com/pt/cli/" target="_blank" rel="noopener noreferrer">AWS CLI</a>:
</p>
<pre>sudo apt install awscli<br>aws configure</pre>
<p>
  Para configurar, você deve fornecer a chave e senha com permissão para os serviço
  que deseja utilizar pelo AWS CLI e a região ao qual você vai se conectar. Você
  não precisa definir formato de saída para o uso que faremos.
</p>
<p>
  Você pode testar a configuração de saída de email executando a linha a seguir:
</p>
<pre>aws ses send-email --from remetente@pad.vg --to destinatario@pad.vg --text "Esse é um teste de texto puro." --html "&lt;h1&gt;Olá Mundo/h1&gt;&lt;p&gt;Este é um teste de texto formatado&lt;/p&gt;" --subject "Olá Mundo"</pre>
<p>
  Crie o arquivo de script que será executado pelo crontab periodicamente, no caso,
  também estou salvando dentro do home do usuário:
</p>
<pre>nano checkbackup.sh</pre>
<p>
  Copie o script do link abaixo, prestando atenção nas variáveis a seguir:
</p>
<ul>
  <li>
    BUCKET_PATHS, com o nome de cada repositório que você irá verificar seguindo
    os parâmetros do Rclone;
  </li>
  <li>
    DAYS_THRESHOLD, o número em dias da verificação de arquivos antes de serem
    declarados faltantes;
  </li>
  <li>
    MAILFROM, endereço de e-mail do remetente, este endereço precisa estar aprovado
    no AWS SES, seja uma identidade individual ou do domínio;
  </li>
  <li>MAILTO, endereço do destinatário;</li>
</ul>
<p>
  GitHub:
  <a href="https://github.com/ivancarlosti/Rclone-Check-Backup/blob/main/checkbackup.sh">https://github.com/ivancarlosti/Rclone-Check-Backup/blob/main/checkbackup.sh</a>
</p>
<p>Habilite a execução do arquivo como script:</p>
<pre>chmod +x checkbackup.sh</pre>
<p>Acesse o crontab:</p>
<pre>crontab -e</pre>
<p>
  Adicione a linha que programará a tarefa, no caso, todo dia, às 05:00. Você pode
  construir novas entradas em
  <a href="https://crontab.guru/" target="_blank" rel="noopener noreferrer">crontab.guru</a>&nbsp;caso
  tenha dificuldade. Note que eu navego para a pasta do script que é meu home primeiro,
  para depois executar o script:
</p>
<pre>0 5 * * * cd /home/ubuntu; ./checkbackup.sh &gt;/dev/null 2&gt;&amp;1</pre>
<p>
  Sabe o arquivo e seu script Rclone estará pronto para trabalhar. Você pode testá-lo
  executando:
</p>
<pre>./checkbackup.sh</pre>
<p>
  Ele não deve retornar nenhum erro, porém se ele retornar uma chave JSON com um
  "MessageID" indica que ele funcionou e enviou uma mensagem de alerta no endereço
  designado.
</p>
