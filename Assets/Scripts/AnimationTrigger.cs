using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationTrigger : MonoBehaviour
{
    public Animator target_animator;
    public string triggerName;


    private void OnTriggerEnter(Collider other)
    {
        print("Something hit trigger");
        target_animator.SetTrigger(triggerName);
        
    }
}
