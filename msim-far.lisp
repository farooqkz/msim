(defun random-choice (L) (nth (random (length L)) L))

(defun vote (citizens)
  (let* ((votes (loop for i in citizens collect (list 0 i))))
    (loop for citizen in citizens do
	 (case citizen
	   ('f (loop for i = (random-choice votes)
		  unless (equal (second i) 'f)
		  do (progn
		       (incf (first i))
		       (return))))
	   ('m (loop for i = (random-choice votes)
		  unless (equal (second i) 'm)
		  do (progn
		       (incf (first i))
		       (return))))
	   ('r (incf (first (random-choice votes))))))
    (second (reduce (lambda (x y) (if (> (first x) (first y)) x y)) votes))))
             

(defun night-kill (citizens)
  (remove (random-choice (remove 'm citizens)) citizens :count 1))
(defun day-lynch (citizens)
  (let ((tmp (vote citizens)))
    (if (equal tmp 'f)
        'fool-win
        (remove tmp citizens :count 1))))

(defun mafiawin? (citizens)
  (when (<= (/ (length citizens) 2) (count 'm citizens))
    t))
(defun towniewin? (citizens)
  (when (zerop (count 'm citizens))
    t))

(defun play-game (citizens)
  (loop
     (setf citizens (night-kill citizens))
     (setf citizens (day-lynch citizens))
     (when (eql 'fool-win  citizens)
       (return 'fool-win))
     (cond
       ((towniewin? citizens) (return 'townie-win))
       ((mafiawin? citizens) (return 'mafia-win)))))

(defun sim (rounds citizens)
  (let ((fool-win 0)
        (mafia-win 0)
        (townie-win 0))
    (loop
       for citizens_ = citizens
       repeat rounds
       do
         (case (play-game citizens_)
           ('fool-win (incf fool-win))
           ('townie-win (incf townie-win))
           ('mafia-win (incf mafia-win))))
         
    (list :f fool-win :m mafia-win :t townie-win)))


(defun sim-mt (nthreads citizens nrounds)
  (let* ((threads (loop
                     repeat nthreads
                     collect (sb-thread:make-thread #'sim :arguments (list nrounds citizens))))
         (result (list :f 0 :m 0  :t 0)))
    (loop for thread in threads do
         (progn
           (incf (getf result :f) (getf (sb-thread:join-thread thread) :f))
           (incf (getf result :m) (getf (sb-thread:join-thread thread) :m))
           (incf (getf result :t) (getf (sb-thread:join-thread thread) :t))))
    result))
