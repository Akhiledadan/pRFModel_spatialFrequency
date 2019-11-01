FasdUAS 1.101.10   ��   ��    k             l     ��  ��    H B Test script to test starting file capture before opening the port     � 	 	 �   T e s t   s c r i p t   t o   t e s t   s t a r t i n g   f i l e   c a p t u r e   b e f o r e   o p e n i n g   t h e   p o r t   
  
 l     ��  ��    N H turn on "Local Echo" and "Capture Local Echo" in the connection options     �   �   t u r n   o n   " L o c a l   E c h o "   a n d   " C a p t u r e   L o c a l   E c h o "   i n   t h e   c o n n e c t i o n   o p t i o n s      l     ��  ��    < 6 for this test. Disable "Wait for termination string".     �   l   f o r   t h i s   t e s t .   D i s a b l e   " W a i t   f o r   t e r m i n a t i o n   s t r i n g " .      l     ��������  ��  ��        l     ��  ��    &   Author: Roger Meier, 02-17-2013     �   @   A u t h o r :   R o g e r   M e i e r ,   0 2 - 1 7 - 2 0 1 3      l     ��  ��      CoolTerm version: 1.4.2     �   0   C o o l T e r m   v e r s i o n :   1 . 4 . 2     !   l     ��������  ��  ��   !  "�� " l    i #���� # O     i $ % $ k    h & &  ' ( ' l   ��������  ��  ��   (  ) * ) l   ��������  ��  ��   *  + , + l   �� - .��   - * $ Get the ID of the first open window    . � / / H   G e t   t h e   I D   o f   t h e   f i r s t   o p e n   w i n d o w ,  0 1 0 r     2 3 2 I   	�� 4��
�� .RBMSwnidnull���     ctxt 4 l    5���� 5 m    ����  ��  ��  ��   3 o      ���� 0 w   1  6 7 6 Z     8 9���� 8 A     : ; : o    ���� 0 w   ; m    ����   9 k     < <  = > = I   �� ?��
�� .sysodisAaleR        TEXT ? m     @ @ � A A  N o   o p e n   w i n d o w s��   >  B�� B L    ����  ��  ��  ��   7  C D C l   ��������  ��  ��   D  E F E l   �� G H��   G R L start the file capture. Select a file path with write access for this test.    H � I I �   s t a r t   t h e   f i l e   c a p t u r e .   S e l e c t   a   f i l e   p a t h   w i t h   w r i t e   a c c e s s   f o r   t h i s   t e s t . F  J K J r    " L M L m      N N � O O > M a c i n t o s h   H D : S h a r e d : c a p t u r e . t x t M o      ���� 0 p   K  P Q P Z   # ; R S���� R H   # , T T l  # + U���� U I  # +�� V��
�� .RBMScpstnull���     ctxt V J   # ' W W  X Y X o   # $���� 0 w   Y  Z�� Z o   $ %���� 0 p  ��  ��  ��  ��   S k   / 7 [ [  \ ] \ I  / 4�� ^��
�� .sysodisAaleR        TEXT ^ m   / 0 _ _ � ` ` . C o u l d   n o t   s t a r t   c a p t u r e��   ]  a�� a L   5 7����  ��  ��  ��   Q  b c b l  < <��������  ��  ��   c  d e d l  < <�� f g��   f   Open the serial port    g � h h *   O p e n   t h e   s e r i a l   p o r t e  i j i Z   < \ k l�� m k I  < A�� n��
�� .RBMSconnnull���     ctxt n o   < =���� 0 w  ��   l k   D T o o  p q p I  D I�� r��
�� .sysodelanull��� ��� nmbr r m   D E���� ��   q  s t s l  J J��������  ��  ��   t  u v u l  J J�� w x��   w   Send some data    x � y y    S e n d   s o m e   d a t a v  z { z I  J R�� |��
�� .RBMSwritnull���     ctxt | J   J N } }  ~  ~ o   J K���� 0 w     ��� � m   K L � � � � �  H e l l o   C o o l t e r m��  ��   {  ��� � l  S S��������  ��  ��  ��  ��   m I  W \�� ���
�� .sysodisAaleR        TEXT � l  W X ����� � m   W X � � � � �  N o t   C o n n e c t e d��  ��  ��   j  � � � l  ] ]��������  ��  ��   �  � � � l  ] ]�� � ���   �   stop the capture    � � � � "   s t o p   t h e   c a p t u r e �  � � � I  ] b�� ���
�� .RBMScpspnull���     ctxt � l  ] ^ ����� � o   ] ^���� 0 w  ��  ��  ��   �  � � � l  c c��������  ��  ��   �  � � � l  c c�� � ���   �   Close the port    � � � �    C l o s e   t h e   p o r t �  ��� � I  c h�� ���
�� .RBMSdiscnull���     ctxt � o   c d���� 0 w  ��  ��   % m      � ��                                                                                  rmCT  alis    R  Macintosh HD               ��]H+  �SYCoolTerm.app                                                   ػ�JJj        ����  	                Mac OS X (Universal)    ����      �J��     �SY�SL 
ߣ 
�� 
� 
�+ 
�L  ~  �Macintosh HD:Users: roger: Documents: Sorted by Application: RealBasic Programs: CoolTerm: Builds - CoolTerm.rbp: Mac OS X (Universal): CoolTerm.app    C o o l T e r m . a p p    M a c i n t o s h   H D  Users/roger/Documents/Sorted by Application/RealBasic Programs/CoolTerm/Builds - CoolTerm.rbp/Mac OS X (Universal)/CoolTerm.app   /    ��  ��  ��  ��       �� � ��� N����   � ��������
�� .aevtoappnull  �   � ****�� 0 w  �� 0 p  ��   � �� ����� � ���
�� .aevtoappnull  �   � **** � k     i � �  "����  ��  ��   �   �  ����� @�� N���� _���� ��� �����
�� .RBMSwnidnull���     ctxt�� 0 w  
�� .sysodisAaleR        TEXT�� 0 p  
�� .RBMScpstnull���     ctxt
�� .RBMSconnnull���     ctxt
�� .sysodelanull��� ��� nmbr
�� .RBMSwritnull���     ctxt
�� .RBMScpspnull���     ctxt
�� .RBMSdiscnull���     ctxt�� j� fjj E�O�j �j OhY hO�E�O��lvj  �j OhY hO�j 	 kj 
O��lvj OPY �j O�j O�j U��  ��   ascr  ��ޭ